--For the sake of performance, Coronas are defined per object

if not LightObjects then rawset(_G, "LightObjects", {}) end

LightObjects[MT_RING] = {
    color = SKINCOLOR_LEMON, --the main color of the corona
    scale = FU/4, --corona scale
    stayondeath = false --the corona will be displayed still on death?
}
LightObjects[MT_SPARK] = {
    color = SKINCOLOR_LEMON,
    scale = FU/2,
    zoffset = -15
}
LightObjects[MT_SUPERSPARK] = {
    color = SKINCOLOR_SILVER,
    scale = FU,
    alpha = FU/2,
    stayondeath = true,
    floorlight = true
}
LightObjects[MT_IVSP] = {
    color = SKINCOLOR_BLUEBELL,
    scale = FU/3,
    alpha = FU/2,
    stayondeath = false,
    zoffset = -35
}
LightObjects[MT_TURRETLASER] = {
    color = SKINCOLOR_SALMON,
    scale = FU/5,
    alpha = FU/2,
    zoffset = -20,
    stayondeath = true
}

LightObjects[MT_EMERALD1] = {color = SKINCOLOR_GREEN, scale = FU/2, alpha = FU-(FU/3/2), floorlight = true}
LightObjects[MT_EMERALD2] = {color = SKINCOLOR_PURPLE, scale = FU/2, alpha = FU-(FU/3/2), floorlight = true}
LightObjects[MT_EMERALD3] = {color = SKINCOLOR_BLUE, scale = FU/2, alpha = FU-(FU/3/2), floorlight = true}
LightObjects[MT_EMERALD4] = {color = SKINCOLOR_BLUEBELL, scale = FU/2, alpha = FU-(FU/3/2), floorlight = true}
LightObjects[MT_EMERALD5] = {color = SKINCOLOR_ORANGE, scale = FU/2, alpha = FU-(FU/3/2), floorlight = true}
LightObjects[MT_EMERALD6] = {color = SKINCOLOR_SALMON, scale = FU/2, alpha = FU-(FU/3/2), floorlight = true}
LightObjects[MT_EMERALD7] = {color = SKINCOLOR_SILVER, scale = FU/2, alpha = FU-(FU/3/2), floorlight = true}