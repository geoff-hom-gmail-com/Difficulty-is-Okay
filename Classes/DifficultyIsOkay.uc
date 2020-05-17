// Couldn't override XComGameState_Investigation.CalcStageDifficultyValue() directly, so calling new CalcStageDifficultyValue() statically.
class DifficultyIsOkay extends Object;

static function int CalcStageDifficultyValue(XComGameState_Investigation Investigation)
{
	local int Difficulty;

	Difficulty = 1; // Default
	switch (Investigation.Stage)
	{
	case eStage_Groundwork:
		Difficulty = 1;
		break;
	case eStage_Takedown:
		Difficulty = 5;
		break;
	case eStage_Operations:
		// Firaxis code has bug: CompletedOperationHistory includes Groundwork.
		// Operations stage difficulty begins at 2, increases by 1 for every completed operation to a max of 4
		// Difficulty = Min(2 + Investigation.CompletedOperationHistory.Length, 4);
		Difficulty = Min(1 + Investigation.CompletedOperationHistory.Length, 4);
		break;
	}

	// "Stage Difficulty [2]"
	`log("           Stage Difficulty [" $ Difficulty $ "]", , 'XCom_Maps');

	return Difficulty;
}