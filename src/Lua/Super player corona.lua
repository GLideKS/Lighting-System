--Corona for the player, commonly when is Super transformed
--Like in final demo
/*
NOTE: This is NOT a separated corona! is a dummy object for the player.
then the corona spawns if this object is defined on the LightObjects[MT_] table
*/

local function SuperCheck(p)
    if p.powers[pw_super] then return true end --Vanilla Super Form
    if (p.solchar and p.solchar.istransformed) then return true end --Sol Forms
    return false
end

local function PlayerCoronaSpawn(p)
    if not (p.mo and p and p.mo.valid and p.mo.health) then return end

    if SuperCheck(p) then
        if not p.mo.supercorona then
            p.mo.supercorona = P_SpawnMobjFromMobj(p.mo, 0,0,0, MT_PLAYERCORONA)
            p.mo.supercorona.target = p.mo
            p.mo.supercorona.scale = p.mo.scale
            p.mo.supercorona.color = p.mo.color
        end
    elseif p.mo.supercorona then
        p.mo.supercorona = nil
    end
end

local function SuperCoronaThink(mo)
    local t = mo.target
    if not (t and t.player and SuperCheck(t.player)) then P_KillMobj(mo) return end
    if mo.radius - t.radius then mo.radius = t.radius end
    if mo.height - t.height then mo.height = t.height end
    if mo.scale - t.scale then mo.scale = t.scale end
    if mo.color != t.color then mo.color = t.color end
    Corona_Follow(mo, t)
end

addHook("PlayerThink", PlayerCoronaSpawn)
addHook("MobjThinker", SuperCoronaThink, MT_PLAYERCORONA)