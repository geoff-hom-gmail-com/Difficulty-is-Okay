This is the README for the XCOM: Chimera Squad mod 'Difficulty is Okay.' 

This mod fixes a minor bug which makes mission difficulty harder between the 1st and 2nd Operations of Act 1. 

## Background

One thing that affects mission difficulty is the 'stage.' Each Act/faction has 5 stages: Groundwork, each Operation, and Takedown. 

Mission difficulty--Easy/Medium/Difficult/Very Difficult--is set in XComTacticalMissionManager.CalculateAlertLevelFromDifficultyParams(). 
That function gets the stage number via XComGameState_Investigation.CalcStageDifficultyValue(). The latter function has a bug.

As mods can't modify the source code directly, we add to it:

> Override XComGameState_Investigation.CalcStageDifficultyValue(). 

If there's a bug with this mod, you can post to reddit (e.g., xcom2mods) or email me at geoff.hom@gmail.com. Please include the Combat and/or Launch logs. 

> Tip: You can see the bug clearly via the Balance log of a new campaign. For the first mission, it'll show like:

[3047.73] XCom_Maps: ******************** Building Encounters ********************
[3047.73] XCom_Maps: 		Day: [0]
[3047.73] XCom_Maps: 		Difficulty Params: Act:[1] Stage:[1] District:[0]

then for the 2nd mission:

[13166.06] XCom_Maps: 		Day: [1]
[13166.06] XCom_Maps: 		Difficulty Params: Act:[1] Stage:[3] District:[0]

If the mod is working, then on Day 1, the Stage should be 2, not 3.
  
> Tip: This mod prints to the Balance log so you know it's working. Search for 'Difficulty is Okay.'

> Tip: Mod code is at https://github.com/geoffhom/Difficulty-is-Okay.

## Requirements

The mod overrides XComGameState_Investigation.CalcStageDifficultyValue().

TODO: copy this to .json.