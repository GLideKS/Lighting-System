/*---Lighting System Beta by GLide KS---*/

--set this if you have Lighting System inside a subfolder.
--remember to end it with /

local LightingSystem_root = ""

if not LightingSystem_loaded then rawset(_G, "LightingSystem_loaded", false) end --Check for Lighting System's existence
if not LightObjects then rawset(_G, "LightObjects", {}) end --Initialize table for light assignment per object.

if not LightingSystem_loaded then
	dofile(LightingSystem_root.."Freeslots.lua")
	if isdedicatedserver then LightingSystem_loaded = true return end --don't even handle coronas for the dedicated server
	
	--Must load first
	dofile(LightingSystem_root.."Commands.lua")
	dofile(LightingSystem_root.."Functions.lua")
	dofile(LightingSystem_root.."Corona.lua")
	dofile(LightingSystem_root.."Super player corona.lua")
	
	--Light object assignment (Definitions)
	dofile(LightingSystem_root.."Definitions/Vanilla.lua") --Vanilla SRB2
	dofile(LightingSystem_root.."Definitions/Extras.lua") --Lighting System additions

	print("\131LightingSystem loaded sucessfully!")
	LightingSystem_loaded = true
else
	print("\x82\WARNING: LightingSystem already loaded, skipping.")
end