/*---Lighting System by GLide KS---*/

if not LightingSystem_loaded then rawset(_G, "LightingSystem_loaded", false) end --Check for Lighting System's existence
if not LightObjects then rawset(_G, "LightObjects", {}) end --Initialize table for light assignment per object.

if not LightingSystem_loaded then
	dofile("Freeslots.lua")
	if isdedicatedserver then LightingSystem_loaded = true return end --Or else players with different settings gets a time out

	--Must load first
	dofile("Commands.lua")
	dofile("Functions.lua")
	dofile("Corona.lua")
	dofile("Super player corona.lua")
	
	dofile("WallLighting.lua")

	--Light object assignment (Definitions)
	dofile("Definitions/Vanilla.lua") --Vanilla SRB2
	dofile("Definitions/Extras.lua") --Lighting System additions
	dofile("Definitions/Colored Rings.lua") --Colored rings support

	print("\131Lighting System loaded sucessfully!")
	LightingSystem_loaded = true
else
	print("\x82".."WARNING: LightingSystem already loaded, skipping.")
end