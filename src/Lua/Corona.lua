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
rawset(_G, "LoadedObjects", {}) --do NOT modify
local corona_size = CV_FindVar("corona_size")

local postthink_coronas = {}

--nothink coronas thinker. funny right?
local function RemoveOnMove(mo)
    if not mo and mo.valid then
        return
    end

    local t = mo.target
    local z = (mo.floor and t.floorz) or t.z
    local corona_cmobj = mo.cmobj

    --Only remove under these conditions

    if (mo.x - t.x) or (mo.y - t.y) or (mo.z - z) then --when it's moving
        RemoveCorona(mo)
        return
    end

    if corona_cmobj.states --when the state or sprite doesn't match
    and not Corona_State(mo)
        then RemoveCorona(mo)
        return
    end

    if not ringstyles then return end

    --Sync at least these
    if mo.translation != Corona_Color(mo) then mo.translation = Corona_Color(mo) end --use the translation if defined
end

--Initializes a corona/light for `mo` if it's defined on the `LightObjects` table.
---@param mo mobj_t
local function InitCorona(mo)
    if not corona_toggle then --Coronas are off, don't run
        return
    end

    local cmobj = LightObjects[mo.type]

    if not (mo and mo.valid) --for some reason an object sometimes don't exist at spawn??? what is this game
    or mo.coronaspawned then --Already spawned, don't run this again
        return
    end

    if cmobj then
        if (cmobj.hide_on_lite and lite_mode) --do not spawn on lite mode
        or (obj and cmobj.specifichide) then --if it's set to be hidden for this specific object, don't continue.
            return
        end
    end

    --Prepare corona
    local corona = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_GKS_CORONA) --Spawn!
    corona.target = mo
    corona.cmobj = cmobj
    local sizesetting = corona_size.value
    local corona_cmobj = corona.cmobj

    if corona_cmobj.postthinkmove then
        insert(postthink_coronas, corona)
    end

    mo.coronaspawned = true --tell the assigned object that it's corona spawned. to be used when you get a resynch
    P_SetOrigin(corona, mo.x, mo.y, mo.z) --Fixes interpolation issues

    --Set corona scale
    local corona_scale = corona_cmobj.scale or FU
	corona.spritexscale = FixedMul(sizesetting, corona_scale)
    corona.spriteyscale = FixedMul(sizesetting, corona_scale)
    corona.scale = mo.scale

    --Set corona's visual properties
    corona.translation = Corona_Color(corona)
    corona.renderflags = $|corona_rf
    corona.alpha = Corona_Alpha(corona)
    corona.spriteyoffset = Corona_UpdateZOffset(corona, mo)

    if corona_cmobj.fullbright then --Make the object fullbright if defined
        mo.renderflags = $|RF_FULLBRIGHT
    end

    if corona_cmobj.flicker then --Make the object flicker if flicker is true
        corona.state = S_GKS_CORONA_FLICKER
    end

    --Mostly for flipped gravity
    corona.eflags = mo.eflags
    corona.height = mo.height

    --Will it draw on the specific state?
    if corona_cmobj.states then
        if Corona_State(corona) then
            corona.flags2 = $ & ~MF2_DONTDRAW
        else
            corona.flags2 = $|MF2_DONTDRAW
        end
    end

    --Will the corona spawn a floorlight as well?
    if not floorsprites then return end
    if corona_cmobj.floorlight then
        if corona_cmobj.states --Don't even spawn the floorlight if state/sprite doesn't match
        and corona_cmobj.nothink
        and not Corona_State(corona) then
            return
        end

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
    if consoleplayer.NET_coronasloaded then return end

    if corona_toggle then --don't bother to do this if coronas is off
        for mo in mobjs.iterate() do
            if mo.coronaspawned then continue end --obviously don't spawn the corona if it's spawned already

            if (LoadedObjects[mo.type] and LoadedObjects[mo.type].specifichide) then
                continue
            end

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
    if not (mo and mo.valid) then return end --This game is dumb

    local corona_cmobj = mo.cmobj
    local t = mo.target

    if not corona_toggle --Coronas are off
    or (corona_cmobj.hide_on_lite and lite_mode) --Defined to be hidden on lite mode
    or not (t and (t.health or corona_cmobj.stayondeath)) --The object assigned is removed
    or corona_cmobj.specifichide then --Is marked to be specifically hidden (corona_toggle argument)
        RemoveCorona(mo)
        return
    end

    if corona_cmobj.nothink then --Is the corona defined to have a reduced thinker?
        RemoveOnMove(mo)
        return
    end

    local zoffset = Corona_UpdateZOffset(mo, t)

    if mo.translation != Corona_Color(mo) then mo.translation = Corona_Color(mo) end --use the translation if defined
    if mo.alpha - Corona_Alpha(mo) then mo.alpha = Corona_Alpha(mo) end
    if mo.scale - t.scale then mo.scale = t.scale end
    if mo.height - t.height then mo.height = t.height end
    if mo.spriteyoffset - zoffset then mo.spriteyoffset = zoffset end
    mo.eflags = t.eflags --Adapt to flipped gravity

    if not corona_cmobj.postthinkmove then
        Corona_Follow(mo, t)
    end

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
    end

    Corona_Follow(mo, t)
    CoronaSplatScale(mo)

    if t.cmobj.nothink then return end

    --Copy everything from the main corona
	if mo.translation != t.translation then mo.translation = t.translation end
    if mo.alpha != t.alpha then mo.alpha = t.alpha end
    if mo.flags2 != t.flags2 then mo.flags2 = t.flags2 end
    if mo.eflags != t.eflags then mo.eflags = t.eflags end
    if mo.state != t.state then mo.state = t.state end
    if mo.scale - t.scale then mo.scale = t.scale end
end

local function PostThink()
    if gamestate != GS_LEVEL then return end
    --go through all coronas
    for i = #postthink_coronas, 1, -1 do
		local mo = postthink_coronas[i]

		--make sure it exists
        if (mo and mo.valid and mo.target)
        and (mo.type == MT_GKS_CORONA or mo.type == MT_GKS_CORONA_SPLAT) then
            Corona_Follow(mo, mo.target)
        else
            remove(postthink_coronas, i) --otherwise it's useless, remove it
        end
    end
end

--Hook all
addHook("MobjThinker", Corona, MT_GKS_CORONA)
addHook("MobjThinker", CoronaSplat, MT_GKS_CORONA_SPLAT)
addHook("ThinkFrame", LoadCoronaMidJoin)
addHook("PostThinkFrame", PostThink)
