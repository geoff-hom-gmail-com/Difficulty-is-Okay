# Game: XCOM: Chimera Squad. Mod: 'Difficulty is Okay.' 
- There's a bug which makes some missions harder. This mod fixes that. 
- This README is easier to read at the repository: https://github.com/geoffhom/Difficulty-is-Okay.

### Background: General Info on the Bug, Mod
- Each mission has a difficulty: Easy/Medium/Difficult/Very Difficult.
- One factor affecting this is the 'Stage.' Each Act has 5 Stages: Groundwork, 3 hidden Operations, and Takedown. So, the Stage can be 1-5. 
- The bug is that the game thinks it's at the next Stage, so missions are harder.
- You can see the bug in the 'Balance' log. 
    - For the first mission, you'll see something like:
    ```
    [3047.73] XCom_Maps: ******************** Building Encounters ********************
    [3047.73] XCom_Maps: 		Day: [0]  
    [3047.73] XCom_Maps: 		Difficulty Params: Act:[1] Stage:[1] District:[0]
    ```
    - For the second mission:
    ```
    [13166.06] XCom_Maps: 		Day: [1]
    [13166.06] XCom_Maps: 		Difficulty Params: Act:[1] Stage:[3] District:[0]
    ```
    - Note that the Stage skips from 1 to 3. What happened to Stage 2?! That's the bug. 

### Background: Technical Info on the Bug, Mod
- The Stage doesn't affect difficulty linearly. So practically, the bug affects only a subset of missions: In each Act, between the 1st and 2nd **Operations**.
- Mission difficulty is set in `XComTacticalMissionManager.CalculateAlertLevelFromDifficultyParams()`. That function gets the stage difficulty from `XComGameState_Investigation.CalcStageDifficultyValue()`. That latter function has the bug, where the value may be +1.
    - As mods can't modify the source code directly, we add to it:
    - Override `XComGameState_MissionSite.InitMissionDifficulty()`. From there, we bypass `XComGameState_Investigation.CalcStageDifficultyValue()` with our own function.
- If there's a bug with this mod, you can post to reddit (e.g., xcom2mods) or email me at geoff.hom@gmail.com. Please include relevant logs. 
  
> Tip: To let you know it's working, this mod prints to the Balance log. Search for 'Difficulty is Okay.'

> Tip: Missions that have already been created won't be fixed. You have to have the mod working the day before, in game time.

### Requirements

- This mod overrides `XComGameState_MissionSite.InitMissionDifficulty()`. 
- In that function, this mod bypasses `XComGameState_Investigation.CalcStageDifficultyValue()`.