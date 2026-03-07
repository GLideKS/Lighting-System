/*COM_AddCommand("corona_debug", function() --Get coronas count
	print("#Coronas: "..#coronas)
end, COM_LOCAL)*/

--Command to toggle coronas. Coronas are net safe!
COM_AddCommand("corona_toggle", function()
    if corona_toggle then
        corona_toggle = false
        print("\x85\Coronas Disabled.")

		--go through all coronas and delete them
        if gamestate != GS_LEVEL then return end
		for mo in mobjs.iterate() do
			--make sure it exists
			if (mo and mo.valid and mo.type == MT_GKS_CORONA) then
				P_RemoveMobj(mo)
			end
		end
    else
        corona_toggle = true
        print("\x83\Coronas Enabled.")
        if gamestate != GS_LEVEL then return end
        for mo in mobjs.iterate() do
            local cmobj = LightObjects[mo.type]
            if not cmobj then continue end
            InitCorona(mo, mo.type) --this is why the command is placed after the InitCorona function
        end
    end
end, COM_LOCAL)

--Corona Size (acts as a multiplier)
CV_RegisterVar({
	name = "corona_size",
	defaultvalue = 1,
	PossibleValue = {MIN=0, MAX=FU*5},
    flags = CV_FLOAT|CV_CALL,
	func = function(cvar)
		if gamestate != GS_LEVEL then return end
		local sizesetting = cvar.value
		for mo in mobjs.iterate() do
            if mo.type != MT_GKS_CORONA then continue end
			--make sure it exists
			if (mo and mo.valid) then
				mo.spritexscale, mo.spriteyscale = FixedMul(sizesetting, mo.cmobj and mo.cmobj.scale or FU), FixedMul(sizesetting, mo.cmobj and mo.cmobj.scale or FU) --alternative stacked scale
				mo.spriteyoffset = FixedDiv(mo.cmobj.zoffset * FU + FixedDiv(mo.target.height, mo.target.scale), mo.spriteyscale)
			end
		end
	end
})