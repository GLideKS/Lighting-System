--Main corona

freeslot(
	"MT_GKS_CORONA",
	"S_GKS_CORONA",
	"SPR_GKS_CORONA"
)

local MT_GKS_CORONA = MT_GKS_CORONA
local S_GKS_CORONA = S_GKS_CORONA
local SPR_GKS_CORONA = SPR_GKS_CORONA
local FU = FU

states[S_GKS_CORONA] = {SPR_GKS_CORONA, FF_FULLBRIGHT|FF_ADD|A, -1, nil, nil, 0, S_GKS_CORONA}
mobjinfo[MT_GKS_CORONA] = {
	spawnstate = S_GKS_CORONA,
	radius = 16*FU,
	height = 16*FU,
	dispoffset = 50,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_SCENERY|MF_NOCLIPHEIGHT|MF_NOCLIP
}

--Corona floorsprite, currently experimental

freeslot("MT_GKS_CORONA_SPLAT", "S_GKS_CORONA_SPLAT")

local MT_GKS_CORONA_SPLAT = MT_GKS_CORONA_SPLAT
local S_GKS_CORONA_SPLAT = S_GKS_CORONA_SPLAT

states[S_GKS_CORONA_SPLAT] = {SPR_GKS_CORONA, FF_FULLBRIGHT|FF_ADD|FF_FLOORSPRITE|A, -1, nil, nil, 0, S_GKS_CORONA_SPLAT}
mobjinfo[MT_GKS_CORONA_SPLAT] = {
	spawnstate = S_GKS_CORONA_SPLAT,
	radius = 32*FU,
	height = 8*FU,
	dispoffset = 1,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_SCENERY|MF_NOCLIPHEIGHT|MF_NOCLIP --Floorsprite coronas follows the corona's flags in the MobjThink
}

--For the superform corona

freeslot("MT_PLAYERCORONA", "S_PLAYERCORONA")

states[S_PLAYERCORONA] = {SPR_NULL, A, -1, nil, nil, 0, S_PLAYERCORONA}
mobjinfo[MT_PLAYERCORONA] = {
	doomednum = -1,
	spawnstate = S_PLAYERCORONA,
	radius = mobjinfo[MT_PLAYER].radius,
	height = mobjinfo[MT_PLAYER].height,
	dispoffset = 1,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_SCENERY|MF_NOCLIPHEIGHT|MF_NOCLIP
}