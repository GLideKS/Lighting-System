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
local postthink_coronas = {}

local function RemoveOnMove(mo)
    local t = mo.target
    local corona_cmobj = mo.cmobj

    if not (t and (t.health or corona_cmobj.stayondeath))
    or (mo.floor and not floorsprites) then
        P_RemoveMobj(mo)
        return
    end
    local z = (mo.floor and t.floorz) or t.z
    if (mo.x - t.x) or (mo.y - t.y) or (mo.z - z) then P_RemoveMobj(mo) return end

    --kill the corona if the defined state doesn't match
    if corona_cmobj.states and not Corona_State(mo) then P_RemoveMobj(mo) return end
end

--Initializes a corona/light for `mo` if it's defined on the `LightObjects` table.
---@param mo mobj_t
local function InitCorona(mo)
    local cmobj = LightObjects[mo.type]
    local sizesetting = corona_size.value

    if (cmobj.hide_on_lite and lite_mode) then return end --do not spawn on lite mode

    --Prepare corona
    local corona = P_SpawnMobjFromMobj(mo, 0,0,0, MT_GKS_CORONA)
    corona.target = mo
    corona.cmobj = cmobj
    local corona_cmobj = corona.cmobj
    local state_is_table = (corona_cmobj.states and type(corona_cmobj.states[mo.state]) == "table")
    if corona_cmobj.postthinkmove then insert(postthink_coronas, corona) end
    mo.coronaspawned = true --tell the assigned object that it's corona spawned. to be used when you get a resynch

    --Set corona scale
    local corona_zoffset = corona_cmobj.zoffset or 0
    local corona_scale = corona_cmobj.scale or FU
	corona.spritexscale, corona.spriteyscale = FixedMul(sizesetting, corona_scale), FixedMul(sizesetting, corona_scale)
	corona.spriteyoffset = FixedDiv(corona_zoffset * FU + FixedDiv(mo.height, mo.scale), corona.spriteyscale)
    corona.scale = mo.scale

    -- Translations over colors (probably redundant)
	-- If someone passed a direct translation
	-- That doesn't cross 0:31, that's on them
    local translation = (state_is_table and corona_cmobj.states[mo.state].translation) or corona_cmobj.translation
	if translation then
		corona.translation = Corona_Color(corona)
        corona.state = S_GKS_CORONA_B
	else
		corona.color = Corona_Color(corona)
		corona.colorized = true
	end

    --Set corona's visual properties
    corona.renderflags = $|corona_rf
    corona.alpha = Corona_Alpha(corona)
    if corona_cmobj.fullbright then mo.renderflags = $|RF_FULLBRIGHT end --Make the object fullbright if defined
    if corona_cmobj.flicker then
        if corona.translation then corona.state = S_GKS_CORONA_B_FLICKER
        else corona.state = S_GKS_CORONA_A_FLICKER
        end
    end

    --Mostly for flipped gravity
    corona.eflags = mo.eflags

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
        CoronaSplatScale(floorlight)

        if translation then
            floorlight.translation = Corona_Color(corona)
            floorlight.state = S_GKS_CORONA_B
        else
            floorlight.color = Corona_Color(corona)
            floorlight.colorized = true
        end
    end
end
rawset(_G, "InitCorona", InitCorona)

--Assign coronas for the defined object types in the LightObjects table

addHook("AddonLoaded", function()
    for i in pairs(LightObjects) do
        if LoadedObjects[i] then continue end --Is already defined, skip

        addHook("MobjSpawn", function(mo)
            if not corona_toggle then return end
            InitCorona(mo) --initialize corona
        end, i)
        LoadedObjects[i] = true --local table

        print("Corona added for object "..i)
    end
end)

--Hacky way to load coronas on server mid-join
local function LoadCoronaMidJoin()
    if not consoleplayer then return end
    if not (multiplayer and netgame) then return end --Only do this for multiplayer servers

    if (corona_toggle and not consoleplayer.NET_coronasloaded) then --don't bother to do this if coronas is off
        for mo in mobjs.iterate() do
            if mo.coronaspawned then continue end --obviously don't spawn the corona if it's spawned already
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
    local corona_cmobj = mo.cmobj
    if corona_cmobj.nothink then RemoveOnMove(mo) return end

    local t = mo.target
    if not (t and (t.health or mo.stayondeath)) then
        P_RemoveMobj(mo)
        return
    end

    local state_ref = corona_cmobj.states and corona_cmobj.states[t.state]
	local translation = (type(state_ref) == "table" and state_ref.translation) or corona_cmobj.translation
    local color = Corona_Color(mo)
    local alpha = Corona_Alpha(mo)

    if translation then mo.translation = color --use the translation if defined
    else mo.color = color --give it a normal color then
    end
    mo.alpha = alpha
    if mo.scale - t.scale then mo.scale = t.scale end
    if not corona_cmobj.postthinkmove then Corona_Follow(mo, t) end

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
    if not (t and floorsprites) then P_RemoveMobj(mo) return end
    if t.cmobj.nothink then return end

    local t_state = t.state

    --Copy everything from the main corona
	if mo.translation != t.translation then mo.translation = t.translation end
    if mo.color != t.color then mo.color = t.color end
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
    for i = #postthink_coronas, 1, -1 do
		local mo = postthink_coronas[i]
		--make sure it exists
        if (mo and mo.valid and mo.target and (mo.type == MT_GKS_CORONA or mo.type == MT_GKS_CORONA_SPLAT)) then
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
