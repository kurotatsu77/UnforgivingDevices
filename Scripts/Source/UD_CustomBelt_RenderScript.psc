Scriptname UD_CustomBelt_RenderScript extends UD_CustomDevice_RenderScript  

Function InitPost()
	UD_ActiveEffectName = "Activate plug"
	UD_DeviceType = "Belt"
EndFunction

Function patchDevice()
	UDCDmain.UDPatcher.patchBelt(self)
EndFunction

bool Function canBeActivated()
	;/
	int loc_num = UDCDmain.getNumberOfDevicesWithKeyword(getWearer(),libs.zad_deviousPlug)
	if loc_num > 0
		return true
	endif
	return false
	/;
	if getWearer().wornhaskeyword(libs.zad_deviousPlug) && getRelativeElapsedCooldownTime() >= 0.25
		if UDCDmain.getVibratorNum(getWearer())
			return true
		endif
	else
		return false
	endif
EndFunction

Function activateDevice()
	int loc_num = UDCDmain.getNumberOfDevicesWithKeyword(getWearer(),libs.zad_deviousPlug)
	if loc_num > 0
		UD_CustomDevice_RenderScript[] loc_plugs_arr = UDCDmain.getAllDevicesByKeyword(getWearer(),libs.zad_deviousPlug)
		UD_CustomDevice_RenderScript loc_plug = loc_plugs_arr[Utility.randomInt(0,loc_num - 1)]
		if WearerIsPLayer()
			debug.notification(getDeviceName() + " activates your plug!")
		elseif WearerIsFollower()
			debug.notification(getWearerName() + "s "+ getDeviceName() +" activates their plug!")
		endif
		if (loc_plug as UD_CustomVibratorBase_RenderScript)
			UD_CustomVibratorBase_RenderScript loc_vibrator = loc_plug as UD_CustomVibratorBase_RenderScript
			
			if loc_vibrator.canVibrate()
				if !loc_vibrator.isVibrating()
					loc_vibrator.ForceModDuration(1.5)
					loc_vibrator.ForceModStrength(1.5)
					loc_vibrator.activateDevice()
					;UDCDmain.startVibFunction(self,true)
				else
					loc_vibrator.addVibDuration(30)
					loc_vibrator.addVibStrength(25)
				endif
			else
				loc_plug.activateDevice()
			endif
		else
			loc_plug.activateDevice()
		endif
	endif
EndFunction
