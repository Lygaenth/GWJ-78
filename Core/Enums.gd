extends Resource
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
	Ending,
	BadEndingPreparation
} 

enum Endings {
	NoMorescenario,
	TooManyMistakes,
	AiDooming
}

enum MemType
{
	Any,
	Start,
	End
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
	Trauma,
	Empty,
	Unknown,
	Aggression,
	Intense,
	Friend,
	Consciousness,
	Alien,
	Illegal,
	AI
}

enum Languages
{
	English,
	French
}
