local coloredrings_loaded = false

local function TryColoredRingsCompat()
    if not ringstyles then return end
    if coloredrings_loaded then return end

    LightObjects[MT_RING].color = nil
    LightObjects[MT_SPARK].color = nil
    LightObjects[MT_FLINGRING].color = nil

    coloredrings_loaded = true
end

TryColoredRingsCompat()
addHook("AddonLoaded", TryColoredRingsCompat)