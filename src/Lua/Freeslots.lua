--Main corona

freeslot(
	"MT_GKS_CORONA",
	"S_GKS_CORONA",
	"S_GKS_CORONA_FLICKER",
	"S_GKS_CORONA_FLICKER2",
	"SPR_GKS_CORONA"
)
local MT_GKS_CORONA = MT_GKS_CORONA
local S_GKS_CORONA = S_GKS_CORONA
local S_GKS_CORONA_FLICKER = S_GKS_CORONA_FLICKER
local FU = FU

function A_CoronaFlicker(mo)
	if not mo.flicker_change then
		mo.sprite = SPR_NULL
		mo.flicker_change = true
	else
		mo.sprite = SPR_GKS_CORONA
		mo.flicker_change = false
	end
end

states[S_GKS_CORONA] = {SPR_GKS_CORONA, FF_FULLBRIGHT|FF_ADD|A, -1, nil, nil, 0, S_GKS_CORONA}
states[S_GKS_CORONA_FLICKER] = {SPR_GKS_CORONA, FF_FULLBRIGHT|FF_ADD|A, 1, A_CoronaFlicker, nil, nil, S_GKS_CORONA_FLICKER}
mobjinfo[MT_GKS_CORONA] = {
	spawnstate = S_GKS_CORONA,
	radius = 16*FU,
	height = 16*FU,
	dispoffset = 50,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_SCENERY|MF_NOCLIPHEIGHT|MF_NOCLIP
}

freeslot("MT_GKS_CORONA_SPLAT")
local MT_GKS_CORONA_SPLAT = MT_GKS_CORONA_SPLAT

mobjinfo[MT_GKS_CORONA_SPLAT] = {
	spawnstate = S_GKS_CORONA,
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