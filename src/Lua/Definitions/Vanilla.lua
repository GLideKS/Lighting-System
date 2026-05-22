-- Vanilla Objects (SRB2)
-- For the sake of performance, Coronas are defined per object

------------Collectibles

LightObjects[MT_RING] = {
    color = SKINCOLOR_YELLOW,
    alpha = FU*3/4,
    scale = FU/4,
    zoffset = -5,
    hide_on_lite = true,
    nothink = true
}

LightObjects[MT_FLINGRING] = {
    color = LightObjects[MT_RING].color,
    scale = LightObjects[MT_RING].scale,
    zoffset = LightObjects[MT_RING].zoffset,
    hide_on_lite = LightObjects[MT_RING].hide_on_lite,
    nothink = false
}

LightObjects[MT_BLUETEAMRING] = {
    color = SKINCOLOR_BLUE,
    scale = LightObjects[MT_RING].scale,
    zoffset = LightObjects[MT_RING].zoffset,
    stayondeath = LightObjects[MT_RING].stayondeath,
    hide_on_lite = LightObjects[MT_RING].hide_on_lite,
    nothink = LightObjects[MT_RING].nothink
}

LightObjects[MT_REDTEAMRING] = {
    color = SKINCOLOR_RED,
    scale = LightObjects[MT_RING].scale,
    zoffset = LightObjects[MT_RING].zoffset,
    stayondeath = LightObjects[MT_RING].stayondeath,
    hide_on_lite = LightObjects[MT_RING].hide_on_lite,
    nothink = LightObjects[MT_RING].nothink
}

LightObjects[MT_TOKEN] = {
    color = SKINCOLOR_SILVER,
    scale = FU/2,
    alpha = FU/3*2,
    floorlight = true,
    stayondeath = true,
    zoffset = -5,
    nothink = true
}

local emmy = { --Emeralds
    scale = FU/2,
    alpha = FU-(FU/3/2),
    floorlight = true,
    zoffset = -10,
    nothink = true
}

LightObjects[MT_EMERALD1] = {
    color = SKINCOLOR_GREEN,
    scale = emmy.scale,
    alpha = emmy.alpha,
    floorlight = emmy.floorlight,
    zoffset = emmy.zoffset,
    nothink = emmy.nothink
}

LightObjects[MT_EMERALD2] = {
    color = SKINCOLOR_PURPLE,
    scale = emmy.scale,
    alpha = emmy.alpha,
    floorlight = emmy.floorlight,
    zoffset = emmy.zoffset,
    nothink = emmy.nothink
}

LightObjects[MT_EMERALD3] = {
    color = SKINCOLOR_BLUE,
    scale = emmy.scale,
    alpha = emmy.alpha,
    floorlight = emmy.floorlight,
    zoffset = emmy.zoffset,
    nothink = emmy.nothink
}

LightObjects[MT_EMERALD4] = {
    color = SKINCOLOR_BLUEBELL,
    scale = emmy.scale,
    alpha = emmy.alpha,
    floorlight = emmy.floorlight,
    zoffset = emmy.zoffset,
    nothink = emmy.nothink
}

LightObjects[MT_EMERALD5] = {
    color = SKINCOLOR_ORANGE,
    scale = emmy.scale,
    alpha = emmy.alpha,
    floorlight = emmy.floorlight,
    zoffset = emmy.zoffset,
    nothink = emmy.nothink
}

LightObjects[MT_EMERALD6] = {
    color = SKINCOLOR_SALMON,
    scale = emmy.scale,
    alpha = emmy.alpha,
    floorlight = emmy.floorlight,
    zoffset = emmy.zoffset,
    nothink = emmy.nothink
}

LightObjects[MT_EMERALD7] = {
    color = SKINCOLOR_SILVER,
    scale = emmy.scale,
    alpha = emmy.alpha,
    floorlight = emmy.floorlight,
    zoffset = emmy.zoffset,
    nothink = emmy.nothink
}

LightObjects[MT_EMERHUNT] = {
    color = SKINCOLOR_GREEN,
    scale = emmy.scale,
    alpha = emmy.alpha,
    floorlight = emmy.floorlight,
    zoffset = emmy.zoffset,
    nothink = emmy.nothink
}

LightObjects[MT_FIREFLOWER] = {
    scale = FU/2,
    zoffset = -7,
    floorlight = true
}

------------Enemies

LightObjects[MT_GOLDBUZZ] = {
    color = SKINCOLOR_YELLOW,
    alpha = FU/3,
    states = {
        [S_BUZZFLY2] = true,
        [S_BUZZLOOK2] = true,
        [S_RBUZZFLY2] = true,
        [S_RBUZZLOOK2] = true
    },
    zoffset = -15
}
LightObjects[MT_REDBUZZ] = LightObjects[MT_GOLDBUZZ]

LightObjects[MT_CRAWLACOMMANDER] = {
    color = SKINCOLOR_RED,
    alpha = FU*2/3,
    scale = FU*2/3,
    states = {
        [S_CCOMMAND1] = true,
        [S_CCOMMAND2] = {alpha = FU/2},
        [S_CCOMMAND3] = {color = SKINCOLOR_YELLOW},
        [S_CCOMMAND4] = {color = SKINCOLOR_YELLOW, alpha = FU/2}
    },
    zoffset = -10
}

------------Interactive objects

LightObjects[MT_STARPOST] = {
    color = SKINCOLOR_SILVER,
    scale = FU,
    alpha = FU/3*2,
    states = {
        [S_STARPOST_FLASH] = true
    },
    zoffset = -30,
    floorlight = true
}

------------Effects

LightObjects[MT_SUPERSPARK] = {
    color = SKINCOLOR_SILVER,
    scale = FU/2,
    alpha = FU/2,
    stayondeath = true,
    floorlight = true,
    zoffset = 15
}

LightObjects[MT_SPARK] = {
    color = SKINCOLOR_YELLOW,
    scale = FU/4,
    alpha = FU/2,
    stayondeath = true,
    zoffset = -15,
    fullbright = true
}

LightObjects[MT_IVSP] = {
    color = SKINCOLOR_BLUEBELL,
    scale = FU/3,
    alpha = FU/2,
    stayondeath = false,
    zoffset = -35
}

LightObjects[MT_JETFUME1] = {
    color = "lightsys_jetfume",
    scale = FU/2,
    alpha = FU/3*2,
    stayondeath = false,
}

LightObjects[MT_METALJETFUME] = {
    scale = LightObjects[MT_JETFUME1].scale,
    stayondeath = LightObjects[MT_JETFUME1].stayondeath,
    floorlight = true,
    states = {[S_JETFUME1] = true, [S_JETFUMEFLASH] = {color = SKINCOLOR_YELLOW}},
    postthinkmove = true
}

LightObjects[MT_PROJECTORLIGHT] = {
    color = SKINCOLOR_GREEN,
    nothink = true
}

LightObjects[MT_EGGROBO1JET] = {
    color = SKINCOLOR_ORANGE,
    scale = FU/2,
    alpha = FU/2,
    zoffset = -10,
    stayondeath = false,
}

LightObjects[MT_MSSHIELD_FRONT] = {
    color = SKINCOLOR_PURPLE,
    scale = FU*6/5,
    alpha = FU/2,
    zoffset = -20,
    floorlight = true
}

LightObjects[MT_BOSSEXPLODE] = {
    color = SKINCOLOR_ORANGE,
    scale = FU/3,
    alpha = FU/3*2,
    stayondeath = true
}

LightObjects[MT_SONIC3KBOSSEXPLODE] = {
    color = LightObjects[MT_BOSSEXPLODE].color,
    scale = LightObjects[MT_BOSSEXPLODE].scale,
    alpha = LightObjects[MT_BOSSEXPLODE].alpha,
    stayondeath = LightObjects[MT_BOSSEXPLODE].stayondeath
}

------------Scenery

LightObjects[MT_CANDLE] = {
    color = SKINCOLOR_ORANGE,
    scale = FU,
    states = {
        [S_CANDLE] = {sprite = SPR_CNDL}
    },
    alpha = FU/3,
    zoffset = -10,
    floorlight = true,
    hide_on_lite = false,
    nothink = true
}

LightObjects[MT_CANDLEPRICKET] = {
    color = LightObjects[MT_CANDLE].color,
    scale = LightObjects[MT_CANDLE].scale,
    alpha = LightObjects[MT_CANDLE].alpha,
    zoffset = LightObjects[MT_CANDLE].zoffset,
    floorlight = LightObjects[MT_CANDLE].floorlight,
    hide_on_lite = LightObjects[MT_CANDLE].hide_on_lite,
    nothink = LightObjects[MT_CANDLE].nothink
}

LightObjects[MT_FIRETORCH] = {
    color = LightObjects[MT_CANDLE].color,
    scale = LightObjects[MT_CANDLE].scale,
    alpha = LightObjects[MT_CANDLE].alpha,
    zoffset = -20,
    floorlight = LightObjects[MT_CANDLE].floorlight,
    hide_on_lite = LightObjects[MT_CANDLE].hide_on_lite,
    nothink = true
}

LightObjects[MT_DBALL] = {
    color = SKINCOLOR_SILVER,
    zoffset = -40,
    alpha = FU/2,
    nothink = true
}

LightObjects[MT_LAMPPOST1] = {
    color = SKINCOLOR_YELLOW,
    zoffset = -20,
    alpha = FU/2,
    floorlight = true,
    nothink = true
}

LightObjects[MT_LAMPPOST2] = {
    color = LightObjects[MT_LAMPPOST1].color,
    zoffset = LightObjects[MT_LAMPPOST1].zoffset,
    alpha = LightObjects[MT_LAMPPOST1].alpha,
    floorlight = LightObjects[MT_LAMPPOST1].floorlight,
    nothink =  LightObjects[MT_LAMPPOST1].nothink
}

------------Projectiles

LightObjects[MT_TURRETLASER] = {
    color = SKINCOLOR_RED,
    scale = FU/5,
    alpha = FU/2,
    zoffset = -20,
    stayondeath = true
}

LightObjects[MT_FIREBALL] = {
    color = SKINCOLOR_ORANGE,
    alpha = FU/2,
    stayondeath = true,
    floorlight = true
}

LightObjects[MT_ENERGYBALL] = {
    color = SKINCOLOR_SKY,
    scale = FU*2,
    alpha = FU*5/6,
    states = {
        [S_ENERGYBALL1] = true
    },
    zoffset = -53,
    stayondeath = true,
    floorlight = true
}

LightObjects[MT_CACOFIRE] = {
    color = SKINCOLOR_BLUE,
    scale = FU/3,
    zoffset = -13
}

LightObjects[MT_CYBRAKDEMON_MISSILE] = {
    color = SKINCOLOR_FLAME,
    scale = FU,
    alpha = FU/2,
    zoffset = -10,
    states = {
        [S_CYBRAKDEMONMISSILE_EXPLODE1] = true,
        [S_CYBRAKDEMONMISSILE_EXPLODE2] = true,
        [S_CYBRAKDEMONMISSILE_EXPLODE3] = true
    },
    floorlight = true
}

------------Weapons

LightObjects[MT_EXPLOSIONRING] = {
    color = SKINCOLOR_SILVER,
    scale = LightObjects[MT_RING].scale,
    zoffset = LightObjects[MT_RING].zoffset,
    stayondeath = LightObjects[MT_RING].stayondeath,
    nothink = LightObjects[MT_RING].nothink
}

LightObjects[MT_AUTOMATICRING] = {
    color = SKINCOLOR_EMERALD,
    scale = LightObjects[MT_RING].scale,
    zoffset = LightObjects[MT_RING].zoffset,
    stayondeath = LightObjects[MT_RING].stayondeath,
    nothink = LightObjects[MT_RING].nothink
}

LightObjects[MT_BOUNCERING] = {
    color = SKINCOLOR_ORANGE,
    scale = LightObjects[MT_RING].scale,
    zoffset = LightObjects[MT_RING].zoffset,
    stayondeath = LightObjects[MT_RING].stayondeath,
    nothink = LightObjects[MT_RING].nothink
}

LightObjects[MT_RAILRING] = {
    color = SKINCOLOR_BLUEBELL,
    scale = LightObjects[MT_RING].scale,
    zoffset = LightObjects[MT_RING].zoffset,
    stayondeath = LightObjects[MT_RING].stayondeath,
    nothink = LightObjects[MT_RING].nothink
}

LightObjects[MT_INFINITYRING] = {
    color = SKINCOLOR_CHERRY,
    scale = LightObjects[MT_RING].scale,
    zoffset = LightObjects[MT_RING].zoffset,
    stayondeath = LightObjects[MT_RING].stayondeath,
    nothink = LightObjects[MT_RING].nothink
}

LightObjects[MT_GRENADERING] = {
    color = SKINCOLOR_GREEN,
    scale = LightObjects[MT_RING].scale,
    zoffset = LightObjects[MT_RING].zoffset-4,
    stayondeath = LightObjects[MT_RING].stayondeath,
    nothink = LightObjects[MT_RING].nothink
}

LightObjects[MT_SCATTERRING] = {
    color = SKINCOLOR_GALAXY,
    scale = LightObjects[MT_RING].scale,
    zoffset = LightObjects[MT_RING].zoffset,
    stayondeath = LightObjects[MT_RING].stayondeath,
    nothink = LightObjects[MT_RING].nothink
}

LightObjects[MT_LHRT] = {
    color = "lightsys_amyheart",
    alpha = FU/2,
    scale = FU/3,
    zoffset = -10,
}

------------Thrown weapons

LightObjects[MT_REDRING] = {
    scale = FU/6,
    zoffset = LightObjects[MT_RING].zoffset,
    stayondeath = false
}

LightObjects[MT_THROWNEXPLOSION] = {
    color = SKINCOLOR_SILVER,
    scale = LightObjects[MT_REDRING].scale,
    zoffset = LightObjects[MT_REDRING].zoffset,
}

LightObjects[MT_THROWNAUTOMATIC] = {
    color = LightObjects[MT_AUTOMATICRING].color,
    scale = LightObjects[MT_REDRING].scale,
    zoffset = LightObjects[MT_REDRING].zoffset,
}

LightObjects[MT_THROWNBOUNCE] = {
    color = SKINCOLOR_ORANGE,
    scale = LightObjects[MT_REDRING].scale,
    zoffset = LightObjects[MT_REDRING].zoffset,
}

LightObjects[MT_THROWNINFINITY] = {
    color = LightObjects[MT_INFINITYRING].color,
    scale = LightObjects[MT_REDRING].scale,
    zoffset = LightObjects[MT_REDRING].zoffset,
}

LightObjects[MT_THROWNSCATTER] = {
    color = LightObjects[MT_SCATTERRING].color,
    scale = LightObjects[MT_REDRING].scale,
    zoffset = LightObjects[MT_REDRING].zoffset,
}

------------Hazards

LightObjects[MT_PUMA] = {
    color = SKINCOLOR_FLAME,
    alpha = FU/3,
    zoffset = -15
}

LightObjects[MT_SMALLFIREBAR] = {
    color = SKINCOLOR_FLAME,
    scale = FU,
    alpha = FU/2,
    zoffset = -15,
    floorlight = true,
    nothink = true
}

LightObjects[MT_BIGFIREBAR] = {
    color = SKINCOLOR_FLAME,
    scale = FU*2,
    alpha = FU/2,
    zoffset = -40,
    floorlight = true,
    nothink = true
}

LightObjects[MT_FLAMEJETFLAME] = {
    color = SKINCOLOR_FLAME,
    scale = FU/2,
    alpha = FU/2,
    zoffset = 15,
    hide_on_lite = true
}

LightObjects[MT_FLAMEJETFLAMEB] = {
    color = SKINCOLOR_FLAME,
    scale = FU,
    alpha = FU/3,
    zoffset = 5,
    hide_on_lite = true
}

LightObjects[MT_GREENFLAME] = {
    color = SKINCOLOR_EMERALD,
    scale = FU,
    alpha = FU/2,
    zoffset = -15,
    floorlight = true,
    nothink = true
}

LightObjects[MT_CYBRAKDEMON_ELECTRIC_BARRIER] = {
    color = SKINCOLOR_AQUAMARINE,
    scale = FU,
    alpha = FU/3,
    zoffset = -25,
    floorlight = true
}

------------Enemies

LightObjects[MT_PYREFLY] = {
    color = SKINCOLOR_FLAME,
    states = {
        [S_PYREFLY_BURN] = true
    },
    alpha = FU/2,
}

LightObjects[MT_CACOLANTERN] = {
    color = SKINCOLOR_BLUE,
    states = {
        [S_CACO_PREPARE2] = {alpha = FU/3},
        [S_CACO_PREPARE3] = {alpha = FU/3},
        [S_CACO_SHOOT1] = true,
        [S_CACO_SHOOT2] = true
    },
    alpha = FU/3*2
}

LightObjects[MT_SPINBOBERT_FIRE1] = {
    color = SKINCOLOR_COBALT,
    scale = FU/3,
    alpha = FU,
    zoffset = -10
}

LightObjects[MT_SPINBOBERT_FIRE2] = {
    color = LightObjects[MT_SPINBOBERT_FIRE1].color,
    scale = LightObjects[MT_SPINBOBERT_FIRE1].scale,
    alpha = LightObjects[MT_SPINBOBERT_FIRE1].alpha,
    zoffset = LightObjects[MT_SPINBOBERT_FIRE1].zoffset
}

------------Gold boxes
local goldbox = {
    alpha = FU/3,
    states = {
        [S_PITY_GOLDBOX] = true,
        [S_ATTRACT_GOLDBOX] = true,
        [S_FORCE_GOLDBOX] = true,
        [S_ARMAGEDDON_GOLDBOX] = true,
        [S_WHIRLWIND_GOLDBOX] = true,
        [S_ELEMENTAL_GOLDBOX] = true,
        [S_SNEAKERS_GOLDBOX] = true,
        [S_INVULN_GOLDBOX] = true,
        [S_EGGMAN_GOLDBOX] = true,
        [S_GRAVITY_GOLDBOX] = true,
        [S_FLAMEAURA_GOLDBOX] = true,
        [S_BUBBLEWRAP_GOLDBOX] = true,
        [S_THUNDERCOIN_GOLDBOX] = true,
        [S_GOLDBOX_FLICKER] = true
    },
    zoffset = -20,
    stayondeath = true,
    floorlight = true
}

LightObjects[MT_PITY_GOLDBOX] = goldbox
LightObjects[MT_ATTRACT_GOLDBOX] = goldbox
LightObjects[MT_FORCE_GOLDBOX] = goldbox
LightObjects[MT_ARMAGEDDON_GOLDBOX] = goldbox
LightObjects[MT_WHIRLWIND_GOLDBOX] = goldbox
LightObjects[MT_ELEMENTAL_GOLDBOX] = goldbox
LightObjects[MT_SNEAKERS_GOLDBOX] = goldbox
LightObjects[MT_INVULN_GOLDBOX] = goldbox
LightObjects[MT_EGGMAN_GOLDBOX] = goldbox
LightObjects[MT_GRAVITY_GOLDBOX] = goldbox
LightObjects[MT_FLAMEAURA_GOLDBOX] = goldbox
LightObjects[MT_BUBBLEWRAP_GOLDBOX] = goldbox
LightObjects[MT_THUNDERCOIN_GOLDBOX] = goldbox