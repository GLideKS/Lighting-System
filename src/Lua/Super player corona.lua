--Corona for the player, commonly when is Super transformed
--Like in final demo
/*
NOTE: This is NOT a separated corona! is a dummy object for the player.
then the corona spawns if this object is defined on the LightObjects[MT_] table
*/

local function SuperCheck(p)
    if p.powers[pw_super] then return true end --Vanilla Super Form
    if (p.solchar and p.solchar.istransformed) then return true end --Sol Forms
    if (p.powers[pw_carry] == CR_NIGHTSMODE) then return true end --NiGHTS Mode
    return false
end

local function PlayerCoronaSpawn(p)
    if not (p.mo and p and p.mo.valid and p.mo.health) then return end
    local pmo = p.mo

    if (SuperCheck(p) and corona_toggle) then
        if not pmo.supercorona then
            pmo.supercorona = P_SpawnMobjFromMobj(pmo, 0,0,0, MT_PLAYERCORONA)
            pmo.supercorona.target = pmo
            pmo.supercorona.scale = pmo.scale
            pmo.supercorona.color = pmo.color
            pmo.supercorona.height = pmo.height
            pmo.supercorona.eflags = pmo.eflags
        end
    elseif pmo.supercorona then
        P_RemoveMobj(pmo.supercorona)
        pmo.supercorona = nil
    end
end

local function SuperCoronaThink(mo)
    local t = mo.target
    if not (t and t.player and SuperCheck(t.player)) then P_KillMobj(mo) return end
    if mo.radius - t.radius then mo.radius = t.radius end
    if mo.height - t.height then mo.height = t.height end
    if mo.eflags != t.eflags then mo.eflags = t.eflags end
    if mo.scale - t.scale then mo.scale = t.scale end
    Corona_Follow(mo, t)
end

local function ColorAssign()
    for p in players.iterate() do
        if not p.mo then continue end
        local pmo = p.mo
        if not (pmo.supercorona and pmo.supercorona.valid) then continue end

        local scorona = pmo.supercorona
        if scorona.color != pmo.color then scorona.color = pmo.color end
    end
end

addHook("PlayerThink", PlayerCoronaSpawn)
addHook("PostThinkFrame", ColorAssign)
addHook("MobjThinker", SuperCoronaThink, MT_PLAYERCORONA)