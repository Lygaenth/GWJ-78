extends Node
class_name Enums

enum Talker {
	Patient,
	Doctor,
	None
}

enum ScenarioState {
	Opening,
	Operation,
	OperationResult,
	Closing,
	Closed,
	Frying
}

enum GameState {
	WaitingForPatient,
	OnGoingScenario,
	OperatingPatient,	
	PatientLeaving,
	CheckEvent,
	Ending
} 

enum Endings {
	NoMorescenario,
	TooManyMistakes
}

enum MemTag
{
	Family,
	Love,
	Work,
	Happy,
	Sad,
	Group,
	Broken,
	LifePath,
	Confidence,
	Conflict,
	Trauma
}
