--`mo` moves to `t` position only if the positions are different.
--Probably an optimized version of P_MoveOrigin.
---@param mo mobj_t
---@param t mobj_t
local function Corona_Follow(mo, t)
    local flipped = P_MobjFlip(t) == -1
    local tx = t.x
    local ty = t.y
    local tz = t.z

    --Because for some reason if floor height is 0, the floorlight moves to the corona position instead
    --so i can't do tz = (mo.floor and ((flipped and t.ceilingz) or t.floorz)) or t.z
    if mo.floor then tz = (flipped and t.ceilingz) or t.floorz end

    P_MoveOrigin(mo, tx, ty, tz)
end

--Returns the color of the defined corona. if no color is found, it returns the default color.
---@param mo mobj_t
local function Corona_Color(mo)
    local t = mo.target
    local corona_cmobj = mo.cmobj

    local alt = corona_cmobj.color_alt or 0
    local default_color = (corona_cmobj.color_default_translation and t.translation) or t.color or alt or SKINCOLOR_WHITE
    local color = corona_cmobj.color or default_color

    if corona_cmobj.states
    and type(corona_cmobj.states[t.state]) == "table"
    and corona_cmobj.states[t.state].color then
        color = corona_cmobj.states[t.state].color or default_color
    end

    local color_result = (type(color) == "number" and "COLORSCALECLR" .. skincolors[color].ramp[7]) or color

    return color_result
end

local intensity = CV_FindVar("corona_intensity")

--Returns the alpha of the defined corona. if no alpha is found, it returns the default alpha (FRACUNIT)
---@param mo mobj_t
local function Corona_Alpha(mo)
    local t = mo.target
    local corona_cmobj = mo.cmobj
    local alpha = corona_cmobj.alpha or FU

    if corona_cmobj.states
    and type(corona_cmobj.states[t.state]) == "table"
    and corona_cmobj.states[t.state].alpha then
        alpha = corona_cmobj.states[t.state].alpha or FU
    end

    return FixedMul(intensity.value, alpha)
end

local size = CV_FindVar("corona_size")

--Returns the scale of the defined corona. if no scale is found, it returns the default scale (FRACUNIT)
---@param mo mobj_t
local function Corona_Scale(mo)
    local t = mo.target
    local corona_cmobj = mo.cmobj
    local scale = corona_cmobj.scale or FU

    if corona_cmobj.states
    and type(corona_cmobj.states[t.state]) == "table"
    and corona_cmobj.states[t.state].scale then
        scale = corona_cmobj.states[t.state].scale or FU
    end

    return FixedMul(size.value, scale)
end

--If the corona has states defined, returns true if the object's state matches with the defined states.
---@param mo mobj_t
local function Corona_State(mo)
    local corona_cmobj = mo.cmobj
    if not corona_cmobj.states then return false end

    local t = mo.target
    local state = corona_cmobj.states

    if type(state[t.state]) == "table" then --the defined state has specific properties
        local sprite = state[t.state].sprite
        local frame = state[t.state].frame

        if sprite == nil then --not a sprite defined. doesn't matter, show the corona
            return true
        end

        if (sprite == t.sprite) then
            if frame == nil then --No frame field defined? it's fine, show it anyways
                return true
            end

            for _, val in ipairs(frame) do --If the frame field exists, make it sure it matches
                if val == t.frame then
                    return true
                end
            end

            return false -- None of these accomplishes, don't show it.
        else
            return false --The sprite doesn't match, don't show.
        end

    elseif state[t.state] then --the state at least matches, show it.
        return true
    end

    return false
end

--Adjust zoffset according to the object's height or object's center if centered_offset is true.
---@param corona mobj_t
---@param target mobj_t
local function Corona_UpdateZOffset(corona, target)
    local corona_zoffset = corona.cmobj.zoffset or 0
    local height_offset = ((corona.cmobj.centered_offset and target.height/2) or target.height) + (corona.cmobj.follow_spriteoffsets and target.spriteyoffset or 0)

    return FixedDiv(corona_zoffset * FU + FixedDiv(height_offset, target.scale), (corona.spriteyscale or 1))
end

--Scales floorlight (Corona Splat) according to the corona z distance
---@param floorlight mobj_t
local function CoronaSplatScale(floorlight) --This is only for floorlights
    if not floorlight.floor then
        return
    end

    local t = floorlight.target

    --Distance checks to scale the floorsprite
    local t_scale = t.scale
    local tsx, tsy = t.spritexscale, t.spriteyscale
    local targetscale = (tsx + tsy) / 2
    local distZ = abs(floorlight.z - t.z)
    local maxDistZ = 512 * FixedMul(targetscale, t_scale)

    local scale
    if distZ >= maxDistZ then
        scale = targetscale / 2 -- minScale
    else
        local maxScale = (targetscale * 3) / 2
        local minScale = targetscale / 2
        local ratio = FixedDiv(distZ, maxDistZ)
        scale = maxScale - FixedMul(ratio, maxScale - minScale)
    end

    --Set the splat visual scale
    if floorlight.spritexscale - scale then
        floorlight.spritexscale = scale
    end

    if floorlight.spriteyscale - scale then
        floorlight.spriteyscale = scale
    end
end

--Removes the corona properly from the object. This is not just a P_RemoveMobj
---@param mo mobj_t
local function RemoveCorona(mo)
    if not mo.floor and (mo.target and mo.target.valid) then
        mo.target.coronaspawned = false
    end

    P_RemoveMobj(mo)
end

rawset(_G, "Corona_Follow", Corona_Follow)
rawset(_G, "Corona_Color", Corona_Color)
rawset(_G, "Corona_Alpha", Corona_Alpha)
rawset(_G, "Corona_Scale", Corona_Scale)
rawset(_G, "Corona_State", Corona_State)
rawset(_G, "CoronaSplatScale", CoronaSplatScale)
rawset(_G, "Corona_UpdateZOffset", Corona_UpdateZOffset)
rawset(_G, "RemoveCorona", RemoveCorona)