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
local insert = table.insert
local remove = table.remove
local corona_rf = RF_NOCOLORMAPS|RF_NOSPLATBILLBOARD|RF_BRIGHTMASK
local splat_rf = corona_rf|RF_SLOPESPLAT|RF_OBJECTSLOPESPLAT
local ff = FF_FULLBRIGHT|FF_ADD
local ff_splat = FF_FULLBRIGHT|FF_ADD|FF_FLOORSPRITE

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
local nothink_coronas = {}

local function RemoveOnMove(mo)
    local t = mo.target

    if not (t and (t.health or mo.stayondeath))
    or (mo.floor and not floorsprites) then
        P_RemoveMobj(mo)
        return
    end
    local z = (mo.floor and t.floorz) or t.z
    if (mo.x - t.x) or (mo.y - t.y) or (mo.z - z) then P_RemoveMobj(mo) end
end

--Initializes a corona/light for `mo` if it's defined on the `LightObjects` table.
---@param mo mobj_t
local function InitCorona(mo)
    local cmobj = LightObjects[mo.type]
    if (cmobj.hide_on_lite and lite_mode) then return end --do not spawn on lite mode

    --Prepare corona
    local sizesetting = corona_size.value
    local corona = P_SpawnMobjFromMobj(mo, 0,0,0, MT_GKS_CORONA)
    corona.target = mo
    P_SetOrigin(corona, mo.x, mo.y, mo.z)
    mo.coronaspawned = true

    --Romoney5 Suggestion: Remove the need of having to access the table in the thinker
    corona.cmobj = cmobj
    corona.stayondeath = cmobj.stayondeath
    corona.states = cmobj.states
    corona.flicker = cmobj.flicker
    corona.coronascale = cmobj.scale or FU
    corona.zoffset = cmobj.zoffset or 0
    corona.nothink = cmobj.nothink
    corona.postthinkmove = cmobj.postthinkmove

    if corona.nothink then
        insert(nothink_coronas, corona)
        corona.flags = $|MF_NOTHINK
    end

    if corona.postthinkmove then insert(postthink_coronas, corona) end

    local state_is_table = (corona.states and type(corona.states[mo.state]) == "table")

    --Set corona scale
	corona.spritexscale, corona.spriteyscale = FixedMul(sizesetting, corona.coronascale), FixedMul(sizesetting, corona.coronascale)
	corona.spriteyoffset = FixedDiv(corona.zoffset * FU + FixedDiv(mo.height, mo.scale), corona.spriteyscale)
    corona.scale = mo.scale

    local translation = (state_is_table and corona.states[mo.state].translation) or corona.cmobj.translation
	if translation then
		-- Translations over colors (probably redundant)
		-- If someone passed a direct translation
		-- That doesn't cross 0:31, that's on them
		corona.translation = Corona_Color(corona)
        corona.state = S_GKS_CORONA_B
	else
		corona.color = Corona_Color(corona)
		corona.colorized = true
	end

    --Set corona's visual properties
    corona.renderflags = $|corona_rf
    corona.alpha = Corona_Alpha(corona)
    if corona.flicker then
        if corona.translation then corona.state = S_GKS_CORONA_B_FLICKER
        else corona.state = S_GKS_CORONA_A_FLICKER
        end
    end

    --Mostly for flipped gravity
    corona.eflags = mo.eflags

    --Will it draw on the specific state?
    if cmobj and cmobj.states then
        if Corona_State(corona) then
			corona.flags2 = $ & ~MF2_DONTDRAW
        else
            corona.flags2 = $|MF2_DONTDRAW
        end
    end

    --Will the corona spawn a floorlight as well?
    if not floorsprites then return end
    if cmobj and cmobj.floorlight then
        local floorlight = P_SpawnMobj(corona.x, corona.y, corona.floorz, MT_GKS_CORONA_SPLAT)
        floorlight.scale = corona.scale
		floorlight.floor = true --and mark it as a floor light
        floorlight.target = corona

        if corona.nothink then
            insert(nothink_coronas, floorlight)
            floorlight.flags = $|MF_NOTHINK
        end

        if corona.translation then
            floorlight.translation = corona.translation
        else
            floorlight.color = corona.color
        end

        floorlight.alpha = corona.alpha
		floorlight.radius = mo.radius
        floorlight.renderflags = $|corona_rf|FF_FLOORSPRITE
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
            InitCorona(mo)
        end, i)
        LoadedObjects[i] = true
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
---@param mo mobj_t
local function Corona(mo)
    if mo.nothink then return end

    local t = mo.target

    if not (t and (t.health or mo.stayondeath)) then
        P_RemoveMobj(mo)
        return
    end

    local tscale = t.scale
    local teflags = t.eflags
    local tstate = t.state

    if mo.scale - t.scale then mo.scale = tscale end
    if not mo.postthinkmove then
        Corona_Follow(mo, t)
    end

    --Adapt to flipped gravity
    mo.eflags = t.eflags

    --Will it draw on the specific state?
    local mo_states = mo.states
    if not mo_states then return end

    if Corona_State(mo) then
        mo.flags2 = $ & ~MF2_DONTDRAW

        --Set the color and alpha from the state if available
        local state_ref = mo_states[tstate]
		local translation = (type(state_ref) == "table" and state_ref.translation) or mo.cmobj.translation
        local color = Corona_Color(mo)
        local alpha = Corona_Alpha(mo)

        if translation then
            mo.translation = color
        else
            mo.color = color
        end

		if mo.alpha != alpha then mo.alpha = alpha end
    elseif not (mo.flags2 & MF2_DONTDRAW) then
        mo.flags2 = $|MF2_DONTDRAW
    end
end

--Corona floorsprite

local function CoronaSplat(mo)
    if mo.nothink then return end

    local t = mo.target

    if not (t and floorsprites) then
        P_RemoveMobj(mo)
        return
    end

    --Distance checks to scale the floorsprite
    local t_scale = t.scale
    local t_state = t.state
    local tsx, tsy = t.spritexscale, t.spriteyscale
    local targetscale = (tsx + tsy) / 2
    local distZ = abs(mo.z - t.z)
    local maxDistZ = 512 * FixedMul(targetscale, t_scale)

    local scale
    if distZ >= maxDistZ then
        scale = targetscale / 2 -- minScale
    else
        local maxScale = (targetscale * 3) / 2
        local minScale = targetscale / 2
        local ratio = FixedDiv(distZ, maxDistZ)
        scale = maxScale - FixedMul(ratio, maxScale - minScale)
    end

    --Copy everything from the main corona
	if mo.translation != t.translation then mo.translation = t.translation end
    if mo.color != t.color then mo.color = t.color end
    if mo.alpha != t.alpha then mo.alpha = t.alpha end
    if mo.flags2 != t.flags2 then mo.flags2 = t.flags2 end
    if mo.eflags != t.eflags then mo.eflags = t.eflags end

    if mo.state != t_state then mo.state = t_state end
    if mo.spritexscale - scale then mo.spritexscale = scale end
    if mo.spriteyscale - scale then mo.spriteyscale = scale end
    if mo.scale - t.scale then mo.scale = t.scale end
    local flipped = P_MobjFlip(t) == -1
    local z = (flipped and t.ceilingz) or t.floorz
    if ((mo.x - t.x) or (mo.y - t.y) or (mo.z - z)) then --move it
        P_MoveOrigin(mo, t.x, t.y, z)
    end
end

local function PostThink()
    if gamestate != GS_LEVEL then return end
    --go through all coronas
    for i = #postthink_coronas, 1, -1 do
		local mo = postthink_coronas[i]
		--make sure it exists
        if (mo and mo.valid and mo.target) then
            local t = mo.target
            Corona_Follow(mo, t)
        else
            remove(postthink_coronas, i) --otherwise it's useless, remove it
        end
    end

    for i = #nothink_coronas, 1, -1 do
		local mo = nothink_coronas[i]
		--make sure it exists
        if (mo and mo.valid and mo.target) then
            RemoveOnMove(mo)
        else
            remove(nothink_coronas, i) --otherwise it's useless, remove it
        end
    end
end

--Hook all
addHook("MobjThinker", Corona, MT_GKS_CORONA)
addHook("MobjThinker", CoronaSplat, MT_GKS_CORONA_SPLAT)
addHook("ThinkFrame", LoadCoronaMidJoin)
addHook("PostThinkFrame", PostThink)
