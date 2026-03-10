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
local corona_rf = RF_NOCOLORMAPS|RF_NOSPLATBILLBOARD|RF_BRIGHTMASK
local splat_rf = corona_rf|RF_SLOPESPLAT|RF_OBJECTSLOPESPLAT

rawset(_G, "corona_toggle", true) --true by default for testing
rawset(_G, "lite_mode", true) --for performance reasons, true will be the default
rawset(_G, "floorsprites", true) --If lite_mode isn't enough, disable floorsprites lol
local corona_size = CV_FindVar("corona_size")
local LoadedObjects = {} --let's not allow the modification of this

--This could be good in a future so I'm leaving this here
/*
local fov = CV_FindVar("fov") --Romoney5 suggestion
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
    if (cmobj.hide_on_lite and lite_mode) then return end --do not spawn on lite mode
    local corona = P_SpawnMobjFromMobj(mo, 0,0,0, MT_GKS_CORONA)
    corona.target = mo
    corona.cmobj = cmobj --romoney5: remove the need of having to access the table in the thinker
    corona.stayondeath = cmobj.stayondeath
    corona.states = cmobj.states
    corona.flicker = cmobj.flicker
    corona.coronascale = cmobj.scale or FU
    corona.zoffset = cmobj.zoffset or 0
    corona.nothink = cmobj.nothink

    --set the color
    local color = (cmobj.states and cmobj.states[mo.state]
                    and cmobj.states[mo.state][2])
                    or cmobj.color or mo.color or SILVER

    corona.colorized = true
    corona.color = color
	corona.spritexscale, corona.spriteyscale = FixedMul(sizesetting, corona.coronascale), FixedMul(sizesetting, corona.coronascale)
	corona.spriteyoffset = FixedDiv(corona.zoffset * FU + FixedDiv(mo.height, mo.scale), corona.spriteyscale)
    corona.scale = mo.scale
    corona.renderflags = $|corona_rf
	P_SetOrigin(corona, mo.x, mo.y, mo.z)
    corona.alpha = (cmobj.alpha or FU)-1

    --Will it draw on the specific state?
    if cmobj and cmobj.states then
        if cmobj.states[mo.state] then
			corona.flags2 = $ & ~MF2_DONTDRAW
        else
            corona.flags2 = $|MF2_DONTDRAW
        end
    end

    mo.coronaspawned = true

    --Will the corona spawn a floorlight as well?
    if not floorsprites then return end
    if cmobj and cmobj.floorlight then
        local floorlight = P_SpawnMobj(corona.x, corona.y, corona.floorz, MT_GKS_CORONA_SPLAT)
        floorlight.scale = corona.scale
		floorlight.floor = true --and mark it as a floor light
		floorlight.nothink = cmobj.nothink
        floorlight.target = corona
        floorlight.color = corona.color
        floorlight.alpha = corona.alpha
		floorlight.radius = mo.radius
        floorlight.renderflags = $|corona_rf
		if not lite_mode then
			floorlight.renderflags = splat_rf
		end
        floorlight.spritexscale = corona.spritexscale
        floorlight.spriteyscale = corona.spriteyscale
    end
end
rawset(_G, "InitCorona", InitCorona)

--Assign coronas for the defined object types in the LightObjects table

addHook("AddonLoaded", function()
    for i in pairs(LightObjects) do
        if LoadedObjects[i] then continue end
        addHook("MobjSpawn", function(mo)
            if not corona_toggle then return end
            InitCorona(mo, i)
        end, i)
        LoadedObjects[i] = true
        print("Corona sucessfully added for object type "..i)
    end
end)

--Hacky way to load coronas on server mid-join
local NET_coronasloaded
local function LoadCoronaMidJoin()
    if not (multiplayer and netgame) then return end --Only do this for multiplayer servers

    if (consoleplayer and consoleplayer.valid) then --to the local player obviously
        if (corona_toggle and not consoleplayer.NET_coronasloaded) then --don't bother to do this if coronas is off
            for mo in mobjs.iterate() do
                if mo.coronaspawned then continue end --obviously don't spawn the corona if it's spawned already
                local cmobj = LightObjects[mo.type]
                if cmobj and not (cmobj.hide_on_lite and lite_mode) then --is lite mode on? don't spawn the hidden corona on lite mode
                    InitCorona(mo, mo.type) --Finally Initialize corona
                end
            end
            NET_coronasloaded = true
            consoleplayer.NET_coronasloaded = true
        end
    elseif NET_coronasloaded then
        NET_coronasloaded = false
    end
end

--Corona Logic
---@param mo mobj_t
local function Corona(mo)
    local t = mo.target
    if not (t and (t.health or mo.stayondeath)) then
        P_RemoveMobj(mo)
        return
    end

	if (mo.nothink or mo.flags & MF_NOTHINK) then return end

    if mo.scale - t.scale then mo.scale = t.scale end
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
    if not mo.target or not floorsprites then
        P_RemoveMobj(mo)
        return
    end

	if (mo.nothink or mo.flags & MF_NOTHINK) then return end

    local t = mo.target

    --Distance checks to scale the floorsprite
    local targetscale = (t.spritexscale+t.spriteyscale)/2
    local maxDistZ = 512 * FixedMul(targetscale, t.scale)
    local maxScale = targetscale*3/2
    local minScale = targetscale / 2
    local distZ = R_PointToDist2(mo.z, mo.z, t.z, t.z)
    local ratio = FixedDiv(distZ, maxDistZ)
    local scale = maxScale - FixedMul(ratio, maxScale - minScale)

    --Copy everything from the main corona
    mo.color = t.color
    mo.alpha = t.alpha
    mo.flags2 = t.flags2
    if mo.spritexscale - scale then mo.spritexscale = scale end
    if mo.spriteyscale - scale then mo.spriteyscale = scale end
    if mo.scale - t.scale then mo.scale = t.scale end
    if ((mo.x - t.x) or (mo.y - t.y) or (mo.z - t.floorz)) then --move it
        P_MoveOrigin(mo, t.x, t.y, t.floorz)
    end
end

--Hook all
addHook("MobjThinker", Corona, MT_GKS_CORONA)
addHook("MobjThinker", CoronaSplat, MT_GKS_CORONA_SPLAT)
addHook("ThinkFrame", LoadCoronaMidJoin)
