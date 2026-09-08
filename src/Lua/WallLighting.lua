--romoney5: wall lighting

local cv_ls_levellight
local cv_ls_levellight_slopes
local cv_ls_levellight_strength
local cv_ls_levellight_angle
local cv_ls_levellight_zangle

--local variables to eliminate indexing overhead and to avoid creating new tables
local strength
local light_normal, temp_normal

local function DotProduct(a, b)
	return FixedMul(a.x, b.x) + FixedMul(a.y, b.y) + FixedMul(a.z, b.z)
end

--calculates the light level of a surface using the dot product from the light normal
--tldr, numbers
local function GetSurfaceLight(light_norm, surface_norm)
	local dot = DotProduct(light_norm, surface_norm)
	
	local light = FixedMul(dot, FU * strength) / FU
	
	return light
end

local function UpdateLightNormals()
	local global_angle = FixedAngle(cv_ls_levellight_angle.value)
	local global_z_angle = FixedAngle(cv_ls_levellight_zangle.value)
	
	strength = cv_ls_levellight_strength.value
	
	light_normal = $ or {}
	light_normal.x, light_normal.y = cos(global_angle), sin(global_angle)
	
	light_normal.z = sin(global_z_angle)
	light_normal.x, light_normal.y =
		FixedMul($, cos(global_z_angle)), FixedMul($, cos(global_z_angle))
	
	temp_normal = $ or {}
	temp_normal.x, temp_normal.y, temp_normal.z = 0, 0, 0
end

--returns the light level for a sidedef
local function GetSideLight(side, side_line, minimal)
	local side_line = side_line or side.line
	local xy_angle = side_line.angle

	if not minimal and side == side_line.backside then
		xy_angle = $ + ANGLE_180
	end
	
	temp_normal.x, temp_normal.y = cos(xy_angle), sin(xy_angle)
	temp_normal.z = 0 --lines are always perfectly vertical
	
	--some maps have really bright sectors and the light effect
	--doesn't work well on them
	local light_diff = max(side.sector.lightlevel - 224, 0)

	return GetSurfaceLight(light_normal, temp_normal) - light_diff
end

--returns the light level for a plane (e.g. floor, ceiling)
local function GetPlaneLight(slope, ceiling)
	--sectors are perfectly horizontal
	temp_normal.x, temp_normal.y = 0, 0
	temp_normal.z = ceiling and -FU or FU
	
	--..unless they have a slope
	if slope then
		local slope_normal = slope.normal
		
		temp_normal.x, temp_normal.y, temp_normal.z =
			slope_normal.x, slope_normal.y, slope_normal.z
		
		--we have to rotate it by 90 degrees though
		temp_normal.x, temp_normal.y = -$2, $1
	end
	
	return GetSurfaceLight(light_normal, temp_normal) --tail call
end

local function ApplyLevelLighting(cvar)
	UpdateLightNormals()
	
	local levellight = cv_ls_levellight.value
	local levellight_slopes = cv_ls_levellight_slopes.value

	for side in sides.iterate do
		if not levellight then
			if cvar then --changed from a cvar
				side.light = 0
				
				continue
			else --map load, don't even bother setting light properties
				break
			end
		end

		side.light = GetSideLight(side)
	end
	
	for sector in sectors.iterate do
		if not (levellight and levellight_slopes) then
			if cvar then --changed from a cvar
				sector.floorlightlevel = 0
				
				continue
			else --map load, don't even bother setting light properties
				break
			end
		end
		
		sector.floorlightlevel = GetPlaneLight(sector.f_slope, false) --floor
		--sector.ceilinglightlevel = GetPlaneLight(sector.c_slope, true) --ceiling
		--ceiling light can mess with fofs/skyboxes
	end
end

--cvars
--these have noinit as the function depends on all cvars to exist

--enable the effect
cv_ls_levellight = CV_RegisterVar{
	name = "ls_levellight",
	defaultvalue = "Off", PossibleValue = CV_OnOff, flags = CV_CALL|CV_NOINIT,
	
	func = ApplyLevelLighting
}

--also enable the effect for slopes
cv_ls_levellight_slopes = CV_RegisterVar{
	name = "ls_levellight_slopes",
	defaultvalue = "On", PossibleValue = CV_OnOff, flags = CV_CALL|CV_NOINIT,
	
	func = ApplyLevelLighting
}

cv_ls_levellight_strength = CV_RegisterVar{
	name = "ls_levellight_strength",
	defaultvalue = "50", PossibleValue = {MIN = 0, MAX = 255}, flags = CV_CALL|CV_NOINIT,
	
	func = ApplyLevelLighting
}

cv_ls_levellight_angle = CV_RegisterVar{
	name = "ls_levellight_angle",
	defaultvalue = "0", PossibleValue = {MIN = -FU * 360, MAX = FU * 360}, flags = CV_CALL|CV_NOINIT|CV_FLOAT,
	
	func = ApplyLevelLighting
}

cv_ls_levellight_zangle = CV_RegisterVar{
	name = "ls_levellight_zangle",
	defaultvalue = "60", PossibleValue = {MIN = -FU * 360, MAX = FU * 360}, flags = CV_CALL|CV_NOINIT|CV_FLOAT,
	
	func = ApplyLevelLighting
}

local all_polyobjs = {}

addHook("MapChange", function()
	all_polyobjs = {}
end)

local function Reset()
	ApplyLevelLighting()
end

addHook("NetVars", Reset)

addHook("MapLoad", function()
	Reset()
	
	--efforts to optimize polyobjects:
	--cache all polyobjects
	for polyobj in polyobjects.iterate do
		local polyobj_lines = polyobj.lines
		
		if not polyobj_lines.valid or not (polyobj.flags & POF_RENDERSIDES) then
			--print("polyobj_lines doesn't exist?! "..#polyobj)
			
			continue
		end
		
		local lua_polyobj = {
			og_polyobj = polyobj,
			angle = polyobj.angle,
			
			lines = {},
			sides = {},
		}
		
		for i = 0, #polyobj_lines - 1 do
			local line = polyobj_lines[i]
			local frontside = line.frontside
			
			if not frontside then continue end --?!
			
			table.insert(lua_polyobj.lines, line)
			table.insert(lua_polyobj.sides, frontside)
		end
		
		table.insert(all_polyobjs, lua_polyobj)
	end
end)

--since polyobjects can rotate, we must update their lights every frame
addHook("ThinkFrame", function()
	if not cv_ls_levellight.value then return end
	
	--last resort optimization, we don't need that much precision for polyobjects
	if leveltime % 5 then return end
	
	for i, polyobj in ipairs(all_polyobjs) do
		local angle = polyobj.og_polyobj.angle
		
		if polyobj.angle == angle then continue end
		polyobj.angle = angle
		
		for ii, side in ipairs(polyobj.sides) do
			side.light = GetSideLight(side, polyobj.lines[ii], true)
		end
	end
end)