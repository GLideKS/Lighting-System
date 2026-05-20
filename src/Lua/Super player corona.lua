--Corona for the player, commonly when is Super transformed
--Like in final demo
/*
NOTE: This is NOT a separated corona! is a dummy object for the player.
then the corona spawns if this object is defined on the LightObjects[MT_] table
*/

local function PlayerCoronaSpawn(mo)
    if not (mo and mo.player and mo.valid and mo.health) then return end

    if mo.player.powers[pw_super] then
        if not mo.supercorona then
            mo.supercorona = P_SpawnMobjFromMobj(mo, 0,0,0, MT_PLAYERCORONA)
            mo.supercorona.target = mo
            mo.supercorona.scale = mo.scale
            mo.supercorona.color = mo.color
        end
    elseif mo.supercorona then
        mo.supercorona = nil
    end
end

local function SuperCoronaThink(mo)
    local t = mo.target
    if not (t and t.player and t.player.powers[pw_super]) then P_KillMobj(mo) return end
    if mo.radius - t.radius then mo.radius = t.radius end
    if mo.height - t.height then mo.height = t.height end
    if mo.scale - t.scale then mo.scale = t.scale end
    if mo.color != t.color then mo.color = t.color end
    Corona_Follow(mo, t)
end

addHook("MobjThinker", PlayerCoronaSpawn, MT_PLAYER)
addHook("MobjThinker", SuperCoronaThink, MT_PLAYERCORONA)