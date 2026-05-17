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

    local state_is_table = (corona_cmobj.states and type(corona_cmobj.states[t.state]) == "table")
    local translation = (state_is_table and corona_cmobj.states[t.state].translation) or corona_cmobj.translation
    local color = (state_is_table and corona_cmobj.states[t.state].color) or corona_cmobj.color or t.color

    if translation then --translation takes priority
        if (type(translation) == "number" or type(translation) == "boolean") then
            local ttype = (type(translation) == "number" and translation) or (type(translation) == "boolean" and t.color)
            -- Maybe they defined a skincolor constant???
            return "COLORSCALECLR" .. skincolors[ttype or SKINCOLOR_GREEN].ramp[7]
        else
            return translation
        end
    elseif color then --then LightObjects[].color
        return color
    else
        return SKINCOLOR_SILVER --if no color found on both, then set to default which is Silver
    end
end

--Returns the alpha of the defined corona. if no alpha is found, it returns the default alpha (FRACUNIT)
---@param mo mobj_t
local function Corona_Alpha(mo)
    local t = mo.target
    local corona_cmobj = mo.cmobj
    local state_is_table = (corona_cmobj.states and type(corona_cmobj.states[t.state]) == "table")

    if (state_is_table and corona_cmobj.states[t.state].alpha) then
        return corona_cmobj.states[t.state].alpha
    elseif corona_cmobj.alpha then
        return corona_cmobj.alpha
    else
        return FU
    end
end

--If the corona has states defined, returns true if the object's state matches with the defined states.
---@param mo mobj_t
local function Corona_State(mo)
    local t = mo.target
    local corona_cmobj = mo.cmobj
    if not (mo and corona_cmobj.states and t) then return false end
    local definition = corona_cmobj.states[t.state]

    if not definition then return false end --Do not show if the state doesn't match

    if definition == true then return true end --It matches, return true

    --The state is a table
    if type(definition) == "table" then
        local target_sprite = definition.sprite

        if target_sprite == nil then return true end --doesn't have a sprite field assigned but the state is written anyways
        if target_sprite == t.sprite then return true end --The sprite matches
    end
    return false
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