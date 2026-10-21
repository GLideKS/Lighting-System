--Lighting System exclusive additions

-- Super corona

local function SuperCheck(p)
    if p.powers[pw_super] then return true end --Vanilla Super Form
    if (p.solchar and p.solchar.istransformed) then return true end --Sol Forms
    if (p.powers[pw_carry] == CR_NIGHTSMODE) then return true end --NiGHTS Mode
    return false
end

LightObjects[MT_PLAYER] = { -- Super player corona.lua
    scale = FU*4/5,
    alpha = FU/2,
    stayondeath = false,
    floorlight = true,
    zoffset = 4,
    thinker = function(corona, pmo)
        if SuperCheck(pmo.player) then
            corona.flags2 = $ & ~MF2_DONTDRAW
        else
            corona.flags2 = $|MF2_DONTDRAW
        end
    end,
    centered_offset = true
}