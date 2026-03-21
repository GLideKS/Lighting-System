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
		for i, mo in ipairs(coronas) do
			--make sure it exists
			if (mo and mo.valid and (mo.type == MT_GKS_CORONA or mo.type == MT_GKS_CORONA_SPLAT)) then
				P_RemoveMobj(mo)
			end
		end

        --and clear it
		coronas = {}
    else
        corona_toggle = true
        print("\x83\Coronas Enabled.")
        if gamestate != GS_LEVEL then return end
        for mo in mobjs.iterate() do
            local cmobj = LightObjects[mo.type]
            if not cmobj then continue end
            InitCorona(mo) --this is why the command is placed after the InitCorona function
        end
    end
end, COM_LOCAL)

--Same as corona_toggle but for hide_on_lite objects
COM_AddCommand("corona_litemode", function()
    if not lite_mode then
        lite_mode = true
        print("\x83\Lite mode Enabled.")

		--go through all coronas and delete them
		if not corona_toggle then return end
        if gamestate != GS_LEVEL then return end
        for i, mo in ipairs(coronas) do
			--make sure it exists
			if (mo and mo.valid and mo.type == MT_GKS_CORONA)
            and LightObjects[mo.target.type].hide_on_lite then
				P_RemoveMobj(mo)
			end
		end
    else
        lite_mode = false
        print("\x85\Lite mode Disabled.")

		if not corona_toggle then return end
        if gamestate != GS_LEVEL then return end
        for mo in mobjs.iterate() do
            local cmobj = LightObjects[mo.type]
            if not cmobj then continue end
			if cmobj.hide_on_lite then
            	InitCorona(mo) --this is why the command is placed after the InitCorona function
			end
        end
    end
end, COM_LOCAL)

--Lite mode isn't enough? disable floorsprites in that case
COM_AddCommand("corona_floorlight", function()
    if floorsprites then
        floorsprites = false
        print("\x85\Floor lights Disabled.")
    else
        floorsprites = true
        print("\x83\Floor lights Enabled.")
		print("\130NOTE:\128Some Floor lights will appear again switching corona_toggle again or in the next map load")
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
		for i, mo in ipairs(coronas) do
			--make sure it exists
			if (mo and mo.valid and (mo.type == MT_GKS_CORONA)) then
				mo.spritexscale, mo.spriteyscale = FixedMul(sizesetting, mo.coronascale or FU), FixedMul(sizesetting, mo.coronascale or FU) --alternative stacked scale
				mo.spriteyoffset = FixedDiv(mo.zoffset * FU + FixedDiv(mo.target.height, mo.target.scale), mo.spriteyscale)
			end
		end
	end
})