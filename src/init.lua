/*---Lighting System Beta by GLide KS---*/

--set this if you have Lighting System inside a subfolder.
--remember to end it with /

local LightingSystem_root = ""

if not LightingSystem_loaded then rawset(_G, "LightingSystem_loaded", false) end

if not LightingSystem_loaded then
	dofile(LightingSystem_root.."Freeslots")
	if isdedicatedserver then LightingSystem_loaded = true return end --don't even handle coronas for the dedicated server
	dofile(LightingSystem_root.."Definitions")
	dofile(LightingSystem_root.."Commands")
	dofile(LightingSystem_root.."Corona")
	dofile(LightingSystem_root.."Super player corona")

	print("\131LightingSystem loaded sucessfully!")
	LightingSystem_loaded = true
else
	print("\x82\WARNING: LightingSystem already loaded, skipping.")
end