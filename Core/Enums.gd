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
	Closed
}

enum GameState {
	WaitingForPatient,
	OnGoingScenario,
	OperatingPatient,	
	PatientLeaving,
	CheckEvent
} 
