--For the sake of performance, Coronas are defined per object


/*
// Example to define objects. you can copy this for your mod or something
// if you want to make it compatible with Lighting System

if not LightObjects then rawset(_G, "LightObjects", {}) end

LightObjects[MT_SOMETHING] = { --MT_SOMETHING is the Object type to assign a corona
    color = SKINCOLOR_SILVER, --corona color
    scale = FU/2, --corona's scale. works the same as mobj_t.scale.
    states = { --if this field is defined, the corona will not render unless you define the states where it appears
        [S_STATE1] = true, --if true, the corona will only appear on this state
        [S_STATE2] = {color = SKINCOLOR_RED}, --if the state is a table, you don't need a true. Instead you can define the color and alpha for the specified state.
        [S_STATE3] = {alpha = FU/2},
        [S_STATE4] = {color = SKINCOLOR_BLUE, alpha = FU/2}
    },
    alpha = FU/3*2, --corona's alpha. works the same as mobj_t.alpha.
    flicker = true, --makes the corona constantly flicker
    floorlight = true, --will the object have a floorsprite corona as well?
    stayondeath = true, --if true, the corona will remain on it's death states
    zoffset = -5, --vertical offset of the corona
    hide_on_lite = true --Used on corona_litemode. if true, the corona will not appear if lite mode is on.
}


// You can copy existing corona definitions for your object too and add other values as well.
// like this example:

LightObjects[MT_SOMETHING] = LightObjects[MT_RING]
LightObjects[MT_SOMETHING].scale = FU
*/

if not LightObjects then rawset(_G, "LightObjects", {}) end

------------Collectibles

LightObjects[MT_RING] = {
    translation = SKINCOLOR_YELLOW,
    scale = FU/4,
    zoffset = -5,
    hide_on_lite = true,
    nothink = true
}

LightObjects[MT_THOK] = {
    translation = SKINCOLOR_RED,
    scale = FU/4,
    zoffset = -5,
    hide_on_lite = true
}

LightObjects[MT_FLINGRING] = {
    translation = LightObjects[MT_RING].translation,
    scale = LightObjects[MT_RING].scale,
    zoffset = LightObjects[MT_RING].zoffset,
    hide_on_lite = LightObjects[MT_RING].hide_on_lite,
    nothink = false
}

LightObjects[MT_BLUETEAMRING] = {
    color = SKINCOLOR_COBALT,
    scale = LightObjects[MT_RING].scale,
    zoffset = LightObjects[MT_RING].zoffset,
    stayondeath = LightObjects[MT_RING].stayondeath,
    hide_on_lite = LightObjects[MT_RING].hide_on_lite,
    nothink = LightObjects[MT_RING].nothink
}

LightObjects[MT_REDTEAMRING] = {
    color = SKINCOLOR_CHERRY,
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
    color = SKINCOLOR_LEMON,
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
        [S_CCOMMAND3] = {color = SKINCOLOR_LEMON},
        [S_CCOMMAND4] = {color = SKINCOLOR_LEMON, alpha = FU/2}
    },
    zoffset = -10
}

------------Interactive objects

LightObjects[MT_STARPOST] = {
    scale = FU,
    alpha = FU/2,
    states = {
        [S_STARPOST_FLASH] = true
    },
    zoffset = -30,
    floorlight = true
}

------------Effects

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

LightObjects[MT_JETFUME1] = {
    color = SKINCOLOR_BLUEBELL,
    scale = FU/2,
    alpha = FU*3/2,
    stayondeath = false,
}

LightObjects[MT_METALJETFUME] = LightObjects[MT_JETFUME1]
LightObjects[MT_METALJETFUME].floorlight = true
LightObjects[MT_METALJETFUME].states = {[S_JETFUME1] = true, [S_JETFUMEFLASH] = {color = SKINCOLOR_YELLOW}}
LightObjects[MT_METALJETFUME].postthinkmove = true

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
    color = SKINCOLOR_GALAXY,
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

LightObjects[MT_SONIC3KBOSSEXPLODE] = LightObjects[MT_BOSSEXPLODE]

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
    hide_on_lite = true,
    nothink = true
}

LightObjects[MT_CANDLEPRICKET] = LightObjects[MT_CANDLE]
LightObjects[MT_FIRETORCH] = LightObjects[MT_CANDLE]
LightObjects[MT_FIRETORCH].states = nil
LightObjects[MT_FIRETORCH].zoffset = -20

LightObjects[MT_DBALL] = {
    zoffset = -40,
    alpha = FU/2,
    nothink = true
}

LightObjects[MT_LAMPPOST1] = {
    color = SKINCOLOR_LEMON,
    zoffset = -20,
    alpha = FU/2,
    floorlight = true,
    nothink = true
}

LightObjects[MT_LAMPPOST2] = LightObjects[MT_LAMPPOST1]

------------Projectiles

LightObjects[MT_TURRETLASER] = {
    color = SKINCOLOR_SALMON,
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
    zoffset = -50,
    stayondeath = true,
    floorlight = true
}

LightObjects[MT_CACOFIRE] = {
    color = SKINCOLOR_BLUE,
    scale = FU/3,
    zoffset = -13
}

LightObjects[MT_CYBRAKDEMON_MISSILE] = {
    color = SKINCOLOR_ORANGE,
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
    color = SKINCOLOR_FANCY,
    alpha = FU/2,
    scale = FU/2,
    zoffset = -10,
}

------------Thrown weapons

LightObjects[MT_REDRING] = {
    scale = FU/6,
    zoffset = LightObjects[MT_RING].zoffset,
    stayondeath = false
}

LightObjects[MT_THROWNEXPLOSION] = {
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
    color = SKINCOLOR_ORANGE,
    alpha = FU/3,
    zoffset = -15
}

LightObjects[MT_SMALLFIREBAR] = {
    color = SKINCOLOR_ORANGE,
    scale = FU,
    alpha = FU/2,
    zoffset = -15,
    floorlight = true,
    nothink = true
}

LightObjects[MT_BIGFIREBAR] = {
    color = SKINCOLOR_ORANGE,
    scale = FU*2,
    alpha = FU/2,
    zoffset = -40,
    floorlight = true,
    nothink = true
}

LightObjects[MT_FLAMEJETFLAME] = {
    color = SKINCOLOR_ORANGE,
    scale = FU/2,
    alpha = FU/2,
    zoffset = 15,
    hide_on_lite = true
}

LightObjects[MT_FLAMEJETFLAMEB] = {
    color = SKINCOLOR_ORANGE,
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
    color = SKINCOLOR_ORANGE,
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
    alpha = FU/2,
    zoffset = -10
}

LightObjects[MT_SPINBOBERT_FIRE2] = LightObjects[MT_SPINBOBERT_FIRE1]

------------Gold boxes
local goldbox = {
    color = SKINCOLOR_SILVER,
    alpha = FU/2,
    zoffset = -20,
    stayondeath = true
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