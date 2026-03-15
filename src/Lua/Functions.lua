local P_MoveOrigin = P_MoveOrigin
local type = type
local FU = FU
local SILVER = SKINCOLOR_SILVER

--`mo` moves to `t` position only if the positions are different.
--Probably an optimized version of P_MoveOrigin.
--Does not work with splats yet
---@param mo mobj_t
---@param t mobj_t
local function Corona_Follow(mo, t)
    local tx = t.x
    local ty = t.y
    local tz = t.z
    local poscheck = (mo.x - tx) or (mo.y - ty) or (mo.z - tz)

    if poscheck then
        P_MoveOrigin(mo, tx, ty, tz)
    end
end

-- This is probably a trivial localdef
-- As this is only used like. once. so far
local skincolors = skincolors
local states = states

--Returns the translation or the color of the defined corona. if no color or translation is found, it returns the default color.
---@param mo mobj_t
local function Corona_Color(mo)
    local t = mo.target

    local state_is_table = (mo.states and type(mo.states[t.state]) == "table")
    local translation = (state_is_table and mo.states[t.state].translation) or mo.cmobj.translation
    local color = (state_is_table and mo.states[t.state].color) or mo.cmobj.color or t.color

    if translation then --translation takes priority
        if type(translation) == "number" then
            -- Maybe they defined a skincolor constant???
            return "COLORSCALECLR" .. skincolors[translation].ramp[7]
        else
            return translation
        end
    elseif color then --then LightObjects[].color
        return color
    else
        return SILVER --if no color found on both, then set to default which is Silver
    end
end

--Returns the alpha of the defined corona. if no alpha is found, it returns the default alpha (FRACUNIT)
---@param mo mobj_t
local function Corona_Alpha(mo)
    local t = mo.target
    local state_is_table = (mo.states and type(mo.states[t.state]) == "table")

    if (state_is_table and mo.states[t.state].alpha) then
        return mo.states[t.state].alpha
    elseif mo.cmobj.alpha then
        return mo.cmobj.alpha
    else
        return FU
    end
end

--If the corona has states defined, returns true if the object's state matches with the defined states.
---@param mo mobj_t
local function Corona_State(mo)
    local t = mo.target
    if not mo.states then return false end

    local state_is_table = type(mo.states[t.state]) == "table"
    local sprite = state_is_table and mo.states[t.state].sprite

    if (sprite == t.sprite) then return true end
    if (not sprite and mo.states[t.state]) then return true end
    return false
end

rawset(_G, "Corona_Follow", Corona_Follow)
rawset(_G, "Corona_Color", Corona_Color)
rawset(_G, "Corona_Alpha", Corona_Alpha)
rawset(_G, "Corona_State", Corona_State)