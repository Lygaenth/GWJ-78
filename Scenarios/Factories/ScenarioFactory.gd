extends Node
class_name ScenarioFactory

const TutoScenarioPs : PackedScene = preload("res://Scenarios/Tuto/TutoScenario.tscn")
const CakeStoryScenarioPs : PackedScene = preload("res://Scenarios/_scenes/CakeStoryScenario.tscn")
const Alzheimer1ScenarioPs : PackedScene = preload("res://Scenarios/_scenes/AlzheimerScenario.tscn")
const Alzheimer2ScenarioPs : PackedScene = preload("res://Scenarios/_scenes/AlzheimerScenario2.tscn")
const AandriskEncounterScenarioPs : PackedScene = preload("res://Scenarios/_scenes/AandriskEncounter.tscn")
const HarmagianEncounterScenarioPs : PackedScene = preload("res://Scenarios/_scenes/HarmagianEncounter.tscn")
const CriminalScenario2Ps : PackedScene = preload("res://Scenarios/_scenes/Criminal.tscn")
const CriminalReturnScenario2Ps : PackedScene = preload("res://Scenarios/_scenes/CriminalReturn.tscn")
const Fulberte1Scenario2Ps : PackedScene = preload("res://Scenarios/_scenes/Fulberte.tscn")
const Fulberte2Scenario2Ps : PackedScene = preload("res://Scenarios/_scenes/Fulberte2.tscn")
const Fulberte3Scenario2Ps : PackedScene = preload("res://Scenarios/_scenes/Fulberte3.tscn")
const Picnic1ScenarioPs : PackedScene = preload("res://Scenarios/_scenes/Picnic.tscn")
const Picnic2ScenarioPs : PackedScene = preload("res://Scenarios/_scenes/Picnic2.tscn")
const MimicScenarioPs : PackedScene = preload("res://Scenarios/_scenes/Mimic.tscn")


const HoloBookScenario1Ps : PackedScene = preload("res://Scenarios/HoloBookWorker/HoloBookScenario1.tscn")
const HoloBookScenario2Ps : PackedScene = preload("res://Scenarios/HoloBookWorker/Part2/HoloBookScenario2.tscn")

var _scenarios : Array[ScenarioBase] = []

func _ready():
	LoadAllScenarios()

func LoadAllScenarios():
	AddScenarioFromPackedScene(TutoScenarioPs)
	AddScenarioFromPackedScene(CakeStoryScenarioPs)
	AddScenarioFromPackedScene(Alzheimer1ScenarioPs)
	AddScenarioFromPackedScene(Alzheimer2ScenarioPs)
	AddScenarioFromPackedScene(AandriskEncounterScenarioPs)
	AddScenarioFromPackedScene(HarmagianEncounterScenarioPs)
	AddScenarioFromPackedScene(CriminalScenario2Ps)
	AddScenarioFromPackedScene(CriminalReturnScenario2Ps)
	AddScenarioFromPackedScene(Fulberte1Scenario2Ps)
	AddScenarioFromPackedScene(Fulberte2Scenario2Ps)
	AddScenarioFromPackedScene(Fulberte3Scenario2Ps)
	AddScenarioFromPackedScene(Picnic1ScenarioPs)
	AddScenarioFromPackedScene(Picnic2ScenarioPs)
	AddScenarioFromPackedScene(MimicScenarioPs)
	
	#AddScenarioFromPackedScene(HoloBookScenario1Ps)
	#AddScenarioFromPackedScene(HoloBookScenario2Ps)

func ResetScenario():
	LoadAllScenarios()

func GetNextScenario() -> ScenarioBase:
	var availableScenars : Array[ScenarioBase] = []
	for scenar : ScenarioBase in _scenarios:
		if(scenar.IsAvailable()):
			availableScenars.append(scenar)
		else:
			scenar.ReduceAvailabilityCounter()
	if (availableScenars.size() == 0):
		return null

	return availableScenars.pick_random()

func AddScenarioFromPackedScene(ps : PackedScene):
	var scenar = ps.instantiate() as ScenarioBase
	scenar.UnlockScenario.connect(OnUnlockScenario)
	add_child(scenar)
	_scenarios.append(scenar)

func OnUnlockScenario(scenarioId : int):
	for scenario in _scenarios:
		if (scenario.Id == scenarioId):
			scenario.AvailabilityCondition = true
