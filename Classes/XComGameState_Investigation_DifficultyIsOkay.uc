class XComGameState_Investigation_DifficultyIsOkay extends XComGameState_Investigation
	// native(Core)
	config(Investigations);

// TODO: add comment (geoffhom; 5.17.2020)
//---------------------------------------------------------------------------------------
// Interprets current stage into a difficulty value (1-5) for an investigation mission 
simulated function int CalcStageDifficultyValue()
{
	local int Difficulty;

	// it's not using this. well, let's commit and dig deeper. it's probably not actually using XComGameState_Investigation, but a subclass. check the type that actually calls CalcStageDifficultyValue().
	`log("           XComGameState_Investigation_DifficultyIsOkay/CalcStageDifficultyValue() called.", , 'XCom_Maps');

	Difficulty = 1; // Default
	switch (Stage)
	{
	case eStage_Groundwork:
		Difficulty = 1;
		break;
	case eStage_Takedown:
		Difficulty = 5;
		break;
	case eStage_Operations:
		// Operations stage difficulty begins at 2, increases by 1 for every completed operation to a max of 4
		Difficulty = Min(2 + CompletedOperationHistory.Length, 4);
		break;
	}

	return Difficulty;
}
