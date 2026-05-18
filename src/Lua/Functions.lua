--`mo` moves to `t` position only if the positions are different.
--Probably an optimized version of P_MoveOrigin.
---@param mo mobj_t
---@param t mobj_t
local function Corona_Follow(mo, t)
    local flipped = P_MobjFlip(t) == -1
    local tx = t.x
    local ty = t.y
    local tz

    --Because for some reason if floor height is 0, the floorlight moves to the corona position instead
    --so i can't do tz = (mo.floor and ((flipped and t.ceilingz) or t.floorz)) or t.z
    if mo.floor then tz = (flipped and t.ceilingz) or t.floorz
    else tz = t.z
    end

    local poscheck = (mo.x - tx) or (mo.y - ty) or (mo.z - tz)
    if poscheck then P_MoveOrigin(mo, tx, ty, tz) end
end

--Returns the translation or the color of the defined corona. if no color or translation is found, it returns the default color.
---@param mo mobj_t
local function Corona_Color(mo)
    local t = mo.target
    local corona_cmobj = mo.cmobj

    local default_color = t.color or SKINCOLOR_WHITE
    local color = corona_cmobj.translation or corona_cmobj.color or default_color
    local color_result = (type(color) == "number" and "COLORSCALECLR" .. skincolors[color].ramp[7]) or color

    if corona_cmobj.states then
        if type(corona_cmobj.states[t.state]) != "table" then return color_result end
        color = corona_cmobj.states[t.state].translation or corona_cmobj.states[t.state].color or default_color
    end
    return color_result
end

--Returns the alpha of the defined corona. if no alpha is found, it returns the default alpha (FRACUNIT)
---@param mo mobj_t
local function Corona_Alpha(mo)
    local t = mo.target
    local corona_cmobj = mo.cmobj
    local alpha = corona_cmobj.alpha or FU

    if corona_cmobj.states then
        if type(corona_cmobj.states[t.state]) != "table" then return alpha end
        alpha = corona_cmobj.states[t.state].alpha or FU
    end
    return alpha
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
        if sprite == nil then return true end --not a sprite defined. doesn't matter, show the corona
        if sprite == t.sprite then return true else return false end --the sprite matches. show the corona, don't if it doesn't.
    elseif state[t.state] then return true end --the state at least matches, show it.

    return false
end

--Adjust zoffset according to the object's height (because I don't want to copy paste the same line again)
---@param corona mobj_t
---@param target mobj_t
local function Corona_UpdateZOffset(corona, target)
    local corona_zoffset = corona.cmobj.zoffset or 0
    return FixedDiv(corona_zoffset * FU + FixedDiv(target.height, target.scale), corona.spriteyscale)
end

--Scales floorlight (Corona Splat) according to the corona z distance
---@param floorlight mobj_t
local function CoronaSplatScale(floorlight)
    if not floorlight.floor then return end --This is only for floorlights

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
    if floorlight.spritexscale - scale then floorlight.spritexscale = scale end
    if floorlight.spriteyscale - scale then floorlight.spriteyscale = scale end
end

rawset(_G, "Corona_Follow", Corona_Follow)
rawset(_G, "Corona_Color", Corona_Color)
rawset(_G, "Corona_Alpha", Corona_Alpha)
rawset(_G, "Corona_State", Corona_State)
rawset(_G, "CoronaSplatScale", CoronaSplatScale)
rawset(_G, "Corona_UpdateZOffset", Corona_UpdateZOffset)