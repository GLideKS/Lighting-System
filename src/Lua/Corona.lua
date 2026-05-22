--Corona System by GLide KS truly optimized for low end pcs
--Credits to Romoney5 for a bit more of optimization
--If you have still lag, use corona_toggle command to disable coronas

--Localize for optimization
local insert = table.insert
local remove = table.remove
local MT_GKS_CORONA = MT_GKS_CORONA
local MT_GKS_CORONA_SPLAT = MT_GKS_CORONA_SPLAT
local corona_rf = RF_NOCOLORMAPS|RF_BRIGHTMASK
local splat_rf = RF_SLOPESPLAT|RF_NOSPLATBILLBOARD|RF_OBJECTSLOPESPLAT|RF_FLOORSPRITE

rawset(_G, "corona_toggle", true)
rawset(_G, "lite_mode", false)
rawset(_G, "floorsprites", true) --If lite_mode isn't enough, disable floorsprites lol
local corona_size = CV_FindVar("corona_size")
rawset(_G, "LoadedObjects", {}) --do NOT modify

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
rawset(_G, "coronas", {})
addHook("MapChange", function()
    coronas = {}
end)

--Initializes a corona/light for `mo` if it's defined on the `LightObjects` table.
---@param mo mobj_t
local function InitCorona(mo)
    if not corona_toggle then return end --Coronas are off, don't run

    if not (mo and mo.valid) then return end --for some reason an object sometimes don't exist at spawn??? what is this game
    if mo.coronaspawned then return end --Already spawned, don't run this again

    --if it's set to be hidden for this specific object, don't continue.
    if LoadedObjects[mo.type].specifichide then return end

    local cmobj = LightObjects[mo.type]
    if (cmobj and cmobj.hide_on_lite and lite_mode) then return end --do not spawn on lite mode

    --Prepare corona
    local sizesetting = corona_size.value
    local corona = P_SpawnMobjFromMobj(mo, 0,0,0, MT_GKS_CORONA)
    corona.target = mo
    corona.cmobj = cmobj
    local corona_cmobj = corona.cmobj
    mo.coronaspawned = true --tell the assigned object that it's corona spawned. to be used when you get a resynch
    insert(coronas, corona)
    P_SetOrigin(corona, mo.x, mo.y, mo.z) --Fixes interpolation issues

    --Set corona scale
    local corona_scale = corona_cmobj.scale or FU
	corona.spritexscale, corona.spriteyscale = FixedMul(sizesetting, corona_scale), FixedMul(sizesetting, corona_scale)
    corona.scale = mo.scale

    -- Translations over colors (probably redundant)
	-- If someone passed a direct translation
	-- That doesn't cross 0:31, that's on them
	corona.translation = Corona_Color(corona)

    --Set corona's visual properties
    corona.renderflags = $|corona_rf
    corona.alpha = Corona_Alpha(corona)
    corona.spriteyoffset = Corona_UpdateZOffset(corona, mo)
    if corona_cmobj.fullbright then mo.renderflags = $|RF_FULLBRIGHT end --Make the object fullbright if defined
    if corona_cmobj.flicker then corona.state = S_GKS_CORONA_FLICKER end

    --Mostly for flipped gravity
    corona.eflags = mo.eflags
    corona.height = mo.height

    --Will it draw on the specific state?
    if corona_cmobj.states then
        if Corona_State(corona) then corona.flags2 = $ & ~MF2_DONTDRAW
        else corona.flags2 = $|MF2_DONTDRAW
        end
    end

    --Will the corona spawn a floorlight as well?
    if not floorsprites then return end
    if corona_cmobj.floorlight then
        if corona_cmobj.states and corona_cmobj.nothink and not Corona_State(corona) then return end --Don't even spawn the floorlight if state/sprite doesn't match

        local floorlight = P_SpawnMobj(corona.x, corona.y, corona.floorz, MT_GKS_CORONA_SPLAT)
        floorlight.floor = true --mark it as a floor light
        floorlight.scale = corona.scale
        floorlight.target = corona
        floorlight.alpha = corona.alpha
		floorlight.radius = corona.radius
        floorlight.renderflags = $|corona_rf|splat_rf
        floorlight.spritexscale = corona.spritexscale
        floorlight.spriteyscale = corona.spriteyscale
        floorlight.translation = corona.translation
        CoronaSplatScale(floorlight)
        insert(coronas, floorlight)
        P_SetOrigin(floorlight, corona.x, corona.y, corona.floorz) --Fixes interpolation issues
    end
end
rawset(_G, "InitCorona", InitCorona)

--Assign coronas for the defined object types in the LightObjects table

addHook("AddonLoaded", function()
    for i in pairs(LightObjects) do
        if LoadedObjects[i] then continue end --Is already defined, skip

        addHook("MobjSpawn", function(mo)
            InitCorona(mo) --initialize corona
        end, i)
        LoadedObjects[i] = {}

        print("Corona added for object "..i)
    end
end)

--Hacky way to load coronas on server mid-join
local function LoadCoronaMidJoin()
    if gamestate != GS_LEVEL then return end
    if not consoleplayer then return end
    if not (multiplayer and netgame) then return end --Only do this for multiplayer servers
    if isserver then return end

    if (corona_toggle and not consoleplayer.NET_coronasloaded) then --don't bother to do this if coronas is off
        for i, corona in ipairs(coronas) do
			--make sure it exists
			if (corona and corona.valid) then
				RemoveCorona(corona)
			end
		end
        coronas = {}
        for mo in mobjs.iterate() do
            if mo.coronaspawned then continue end --obviously don't spawn the corona if it's spawned already
            if (LoadedObjects[mo.type] and LoadedObjects[mo.type].specifichide) then continue end
            local cmobj = LightObjects[mo.type]
            if cmobj and not (cmobj.hide_on_lite and lite_mode) then --is lite mode on? don't spawn the hidden corona on lite mode
                InitCorona(mo) --Finally Initialize corona
            end
        end
        consoleplayer.NET_coronasloaded = true
    end
end

--Corona Logic
--TODO: Add a reduced thinker as well...?
---@param mo mobj_t
local function Corona(mo)
    if not corona_toggle then RemoveCorona(mo) return end

    local t = mo.target
    local corona_cmobj = mo.cmobj
    if not (t and (t.health or corona_cmobj.stayondeath)) then
        RemoveCorona(mo)
        return
    elseif corona_cmobj.nothink then
        if (mo.x - t.x) or (mo.y - t.y) or (mo.z - t.z) then P_RemoveMobj(mo) end
        return
    end

    local zoffset = Corona_UpdateZOffset(mo, t)
    if mo.translation != Corona_Color(mo) then mo.translation = Corona_Color(mo) end --use the translation if defined
    if mo.alpha - Corona_Alpha(mo) then mo.alpha = Corona_Alpha(mo) end
    if mo.scale - t.scale then mo.scale = t.scale end
    if mo.height - t.height then mo.height = t.height end
    if mo.spriteyoffset - zoffset then mo.spriteyoffset = zoffset end
    Corona_Follow(mo, t)

    --Adapt to flipped gravity
    mo.eflags = t.eflags

    --Will it draw on the specific state?
    if not corona_cmobj.states then return end
    if Corona_State(mo) then
        mo.flags2 = $ & ~MF2_DONTDRAW
    else
        mo.flags2 = $|MF2_DONTDRAW
    end
end

--Corona floorsprite
local function CoronaSplat(mo)
    local t = mo.target
    if not (t and floorsprites) then
        RemoveCorona(mo)
        return
    elseif t.cmobj.nothink then
        return
    end

    local t_state = t.state

    --Copy everything from the main corona
	if mo.translation != t.translation then mo.translation = t.translation end
    if mo.alpha != t.alpha then mo.alpha = t.alpha end
    if mo.flags2 != t.flags2 then mo.flags2 = t.flags2 end
    if mo.eflags != t.eflags then mo.eflags = t.eflags end
    if mo.state != t_state then mo.state = t_state end
    if mo.scale - t.scale then mo.scale = t.scale end
    CoronaSplatScale(mo)
    Corona_Follow(mo, t)
end

local function PostThink()
    if gamestate != GS_LEVEL then return end
    --go through all coronas
    for i in pairs(coronas) do
		local mo = coronas[i]

		--make sure it exists
        if (mo and mo.valid) then
            if mo.floor then
                CoronaSplat(mo)
            else
                Corona(mo)
            end
        else
            remove(coronas, i) --otherwise it's useless, remove it
        end
    end
end

--Hook all
addHook("ThinkFrame", LoadCoronaMidJoin)
addHook("ThinkFrame", PostThink)
