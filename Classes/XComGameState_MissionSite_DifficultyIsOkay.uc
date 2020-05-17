// So we can replace CurrentInvestigation.CalcStageDifficultyValue() with our own function.
class XComGameState_MissionSite_DifficultyIsOkay extends XComGameState_MissionSite
	// native(Core);
	;

//---------------------------------------------------------------------------------------
// Analyzes board state and populates MissionDifficultyParams data
simulated function InitMissionDifficulty()
{
	local XComGameStateHistory History;
	local XComGameState_DioCityDistrict CityDistrict;
	local XComGameState_HeadquartersDio DioHQ;
	local XComGameState_StrategyAction_Mission MissionAction;
	local XComGameState_DioWorker MissionWorker;
	local X2DioStrategyScheduleSourceTemplate StrategySourceTemplate;
	local XComGameState_Investigation CurrentInvestigation;
	local X2DioInvestigationTemplate InvestigationTemplate;
	local EnemyFactionForceLevelInfo FactionForceLevel;
	local EnemyFactionSpawnInfo FactionSpawnRatio;
	local int i;
	local XComGameState_InvestigationOperation CurrentOperation;
	local bool bOperationMission;

	`log("           XComGameState_MissionSite_DifficultyIsOkay () called.", , 'XCom_Maps');

	// Early out: data mismatch
	if (GeneratedMission.MissionID != ObjectID)
	{
		`warn("XComGameState_MissionSite.InitMissionDifficulty: Generated Mission ID does not match this site");
		return;
	}

	History = `XCOMHISTORY;
	DioHQ = `DIOHQ;
	CityDistrict = XComGameState_DioCityDistrict(History.GetGameStateForObjectID(Region.ObjectID));
	CurrentInvestigation = XComGameState_Investigation(History.GetGameStateForObjectID(DioHQ.CurrentInvestigation.ObjectID));
	InvestigationTemplate = CurrentInvestigation.GetMyTemplate();

	MissionAction = GetMissionAction();
	MissionWorker = MissionAction.GetWorker();

	CurrentOperation = class'DioStrategyAI'.static.GetCurrentOperation();
	bOperationMission = CurrentOperation.MissionWorkerRef.ObjectID == MissionWorker.ObjectID;

	MissionDifficultyParams.Act = CurrentInvestigation.Act;

	// Fixing bug. (geoffhom 5.17.2020)
	// MissionDifficultyParams.Stage = CurrentInvestigation.CalcStageDifficultyValue();
	MissionDifficultyParams.Stage = class'DifficultyIsOkay'.static.CalcStageDifficultyValue(CurrentInvestigation);

	MissionDifficultyParams.District = (bOperationMission) ? 100 : CityDistrict.CalcDistrictDifficultyValue(self);
		
	StrategySourceTemplate = MissionWorker.GetMissionStrategySource();
	if (StrategySourceTemplate != none)
	{
		FactionSpawnRatios = StrategySourceTemplate.FactionSpawnRatios;
	}
	else 
	{
		FactionSpawnRatios.Length = 0;
		// No source? Faction mission, give them 100%
		if (InvestigationTemplate.FactionID != '')
		{
			FactionSpawnRatio.FactionID = InvestigationTemplate.FactionID;
			FactionSpawnRatio.Weight = 100;
			FactionSpawnRatios.AddItem(FactionSpawnRatio);
		}		
	}

	// Fallback case: assume 100% conspiracy since that is safe at any time in the campaign
	if (FactionSpawnRatios.Length == 0)
	{
		`warn("InitMissionDifficulty: no spawn ratios provided, defaulting to 100% Conspiracy spawns @gameplay");
		FactionSpawnRatio.FactionID = 'Conspiracy';
		FactionSpawnRatio.Weight = 100;
		FactionSpawnRatios.AddItem(FactionSpawnRatio);
	}

	// Convert strategy-side faction ratio into Investigation-accurate data
	for (i = 0; i < FactionSpawnRatios.Length; ++i)
	{ 
		if (FactionSpawnRatios[i].FactionID == 'Faction')
		{
			FactionSpawnRatios[i].FactionID = InvestigationTemplate.FactionID;
		}
	}

	// Apply forces levels for all entities included in spawn ratios
	FactionForceLevels.Length = 0;
	for (i = 0; i < FactionSpawnRatios.Length; ++i)
	{
		FactionForceLevel.FactionID = FactionSpawnRatios[i].FactionID;
		FactionForceLevel.ForceLevel = class'XComGameState_Investigation'.static.CalculateForceLevel(CurrentInvestigation, FactionForceLevel.FactionID);
		FactionForceLevels.AddItem(FactionForceLevel);
	}
}