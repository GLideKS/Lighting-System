local coloredrings_loaded = false

local function colored_ringsthink(mo)
    mo.translation = Corona_Color(mo) --use the translation if defined
end

local function TryColoredRingsCompat()
    if not ringstyles then return end
    if coloredrings_loaded then return end

    LightObjects[MT_RING].color = nil
    LightObjects[MT_SPARK].color = nil
    LightObjects[MT_FLINGRING].color = nil
    LightObjects[MT_RING].thinker = colored_ringsthink
    LightObjects[MT_SPARK].thinker = colored_ringsthink
    LightObjects[MT_FLINGRING].thinker = colored_ringsthink

    coloredrings_loaded = true
end

TryColoredRingsCompat()
addHook("AddonLoaded", TryColoredRingsCompat)