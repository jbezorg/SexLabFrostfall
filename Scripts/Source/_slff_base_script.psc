Scriptname _slff_base_script extends questVersioning  

SexLabFramework property SexLab                 auto
GlobalVariable  property exposurePoints = none  auto hidden
float           property exposureDelta = 0.0    auto hidden
float           property exposureMax = 120.0    autoreadonly
float           property exposureAdjust = 15.0  autoreadonly

Actor kPlayer

int Function qvGetVersion()
	return 1
endFunction

function qvUpdate( int aiCurrentVersion )
	; less  000 = Dead
	; 001 - 020 = Freezing to death
	; 021 - 040 = Freezing
	; 041 - 060 = Very cold
	; 061 - 080 = Cold
	; 081 - 100 = Comfortable
	; 101 - 120 = Warm
	exposurePoints = none
	kPlayer        = Game.GetPlayer()
	int idx        = Game.GetModCount()
	bool found     = false

	while idx && !found
		idx -= 1
		if Game.GetModName(idx) == "chesko_frostfall.esp"
			found = true
			exposurePoints = Game.GetFormFromFile(0x00000183d, "chesko_frostfall.esp") as GlobalVariable
		endIf
	endWhile

	if exposurePoints != none
		RegisterForModEvent("StageStart", "stageStart")
	endIf
endFunction

float function minFloat(float afA, float afB)
	if afA < afB
		return afA
	else
		return afB
	endIf
endFunction

event stageStart(string eventName, string argString, float argNum, form sender)
	if exposurePoints != none && SexLab.HookActors(argString).Find(kPlayer) >= 0
		exposureDelta = exposureMax - exposurePoints.GetValue()

		if exposureDelta > 0.0
			exposurePoints.Mod( minFloat(exposureAdjust, exposureDelta) )
		endIf
	endIf
endEvent

