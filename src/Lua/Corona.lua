--Corona System by GLide KS truly optimized for low end pcs
--Credits to Romoney5 for a bit more of optimization
--If you have still lag, use corona_toggle command to disable coronas

--Localize for optimization
local addHook = addHook
local P_SpawnMobjFromMobj = P_SpawnMobjFromMobj
local P_SpawnMobj = P_SpawnMobj
local P_RemoveMobj = P_RemoveMobj
local P_MoveOrigin = P_MoveOrigin
local P_SetOrigin = P_SetOrigin
local MT_GKS_CORONA = MT_GKS_CORONA
local MT_GKS_CORONA_SPLAT = MT_GKS_CORONA_SPLAT
local FixedMul = FixedMul
local FixedDiv = FixedDiv
local SILVER = SKINCOLOR_SILVER
local RF_NOCOLORMAPS = RF_NOCOLORMAPS
local RF_NOSPLATBILLBOARD = RF_NOSPLATBILLBOARD
local RF_BRIGHTMASK = RF_BRIGHTMASK

rawset(_G, "corona_toggle", true) --true by default for testing
local corona_size = CV_FindVar("corona_size")
local fov = CV_FindVar("fov") --Romoney5 suggestion

--This could be good in a future so I'm leaving this here
/*
local function IsObjectOnSight(mo)
    if not camera then return end
    local ang = AngleFixed(camera.angle)
    local mang = AngleFixed(R_PointToAngle(mo.x, mo.y))

    if ang - mang < FU * -180 then mang = $ - FU * 360
    elseif ang - mang > FU * 180 then mang = $ + FU * 360 end

    local diff = (ang - mang)
    local pfov = fov.value

    if abs(diff) >= pfov then
        return false --out of sight
    end
    return true
end
*/

--Initialize corona for the mobj
local function InitCorona(mo, type)
    local sizesetting = corona_size.value
    local cmobj = LightObjects[type]
    local corona = P_SpawnMobjFromMobj(mo, 0,0,0, MT_GKS_CORONA)
    local corona_rf = RF_NOCOLORMAPS|RF_NOSPLATBILLBOARD|RF_BRIGHTMASK
    corona.target = mo
    corona.cmobj = cmobj --romoney5: remove the need of having to access the table in the thinker
    corona.stayondeath = cmobj.stayondeath
    corona.states = cmobj.states
    corona.flicker = cmobj.flicker

    --set the color
    local color = (cmobj.states and cmobj.states[mo.state]
                    and cmobj.states[mo.state][2])
                    or cmobj.color or mo.color or SILVER

    corona.colorized = true
    corona.color = color
	corona.spritexscale, corona.spriteyscale = FixedMul(sizesetting, cmobj.scale), FixedMul(sizesetting, cmobj.scale)
	corona.spriteyoffset = FixedDiv(cmobj.zoffset * FU + FixedDiv(mo.height, mo.scale), corona.spriteyscale)
    corona.scale = mo.scale
    corona.renderflags = $|corona_rf
	P_SetOrigin(corona, mo.x, mo.y, mo.z)
    if cmobj.alpha then corona.alpha = cmobj.alpha end

    --Will it draw on the specific state?
    if cmobj and cmobj.states then
        if cmobj.states[mo.state] then
			corona.flags2 = $ & ~MF2_DONTDRAW
        else
            corona.flags2 = $|MF2_DONTDRAW
        end
    end

    --Will the corona spawn a floorlight as well?
    if cmobj and cmobj.floorlight then
        local floorlight = P_SpawnMobj(corona.x, corona.y, corona.floorz, MT_GKS_CORONA_SPLAT)
		floorlight.floor = true --and mark it as a floor light
        floorlight.target = corona
        floorlight.color = corona.color
        floorlight.alpha = corona.alpha
        corona.renderflags = $|corona_rf
        floorlight.spritexscale = corona.spritexscale
        floorlight.spriteyscale = corona.spriteyscale
        floorlight.scale = corona.scale
    end
end
rawset(_G, "InitCorona", InitCorona)

--Assign coronas for the defined object types in the LightObjects table

addHook("AddonLoaded", function()
    for i in pairs(LightObjects) do
        if LightObjects[i].defined then continue end
        addHook("MobjSpawn", function(mo)
            if not corona_toggle then return end
            InitCorona(mo, i)
        end, i)
        LightObjects[i].defined = true
        LightObjects[i].scale = $ or FU
        LightObjects[i].zoffset = $ or 0
        print("Corona sucessfully added for object type "..i)
    end
end)

--Corona Logic
---@param mo mobj_t
local function Corona(mo)
    local t = mo.target
    if not (t and (t.health or mo.stayondeath)) then
        P_RemoveMobj(mo)
        return
    end
	
	mo.scale = t.scale
    if ((mo.x - t.x) or (mo.y - t.y) or (mo.z - t.z)) then --look i needed to shave off 20 microseconds
        P_MoveOrigin(mo, t.x, t.y, t.z)
    end

    if mo.flicker then
        if (mo.flags2 & MF2_DONTDRAW) then
            mo.flags2 = $ & ~MF2_DONTDRAW
        else
            mo.flags2 = $|MF2_DONTDRAW
        end
    end

    --Will it draw on the specific state?
    if not mo.states then return end

    if mo.states[t.state] then
        if not mo.flicker then
		    mo.flags2 = $ & ~MF2_DONTDRAW
        end
        --Set the color from the state if available
        local color = mo.states[t.state][2] or mo.cmobj.color or t.color or SILVER
        if mo.color != color then mo.color = color end
    else
        mo.flags2 = $|MF2_DONTDRAW
    end
end

--Corona floorsprite

local function CoronaSplat(mo)
    if not mo.target then
        P_RemoveMobj(mo)
        return
    end

    local t = mo.target

    --Distance checks to scale the floorsprite
    local targetscale = (t.spritexscale+t.spriteyscale)/2
    local maxDistZ = 512 * targetscale
    local maxScale = targetscale*3/2
    local minScale = targetscale / 2
    local distZ = R_PointToDist2(mo.z, mo.z, t.z, t.z)
    local ratio = FixedDiv(distZ, maxDistZ)
    local scale = maxScale - FixedMul(ratio, maxScale - minScale)

    --Copy everything from the main corona
    mo.color = t.color
    mo.alpha = t.alpha
    mo.flags2 = t.flags2
    mo.spritexscale = scale
    mo.spriteyscale = scale
    if ((mo.x - t.x) or (mo.y - t.y) or (mo.z - t.floorz)) then --move it
        P_MoveOrigin(mo, t.x, t.y, t.floorz)
    end
end

--Hook all
addHook("MobjThinker", Corona, MT_GKS_CORONA)
addHook("MobjThinker", CoronaSplat, MT_GKS_CORONA_SPLAT)