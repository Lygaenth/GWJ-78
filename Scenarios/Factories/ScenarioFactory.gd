extends Node
class_name ScenarioFactory

const TutoScenarioPs : PackedScene = preload("res://Scenarios/Tuto/TutoScenario.tscn")
const CakeStoryScenarioPs : PackedScene = preload("res://Scenarios/CakeStory/CakeStoryScenario.tscn")
const Alzheimer1ScenarioPs : PackedScene = preload("res://Scenarios/Alzheimer/1/AlzheimerScenario.tscn")
const Alzheimer2ScenarioPs : PackedScene = preload("res://Scenarios/Alzheimer/2/AlzheimerScenario2.tscn")
const AandriskEncounterScenarioPs : PackedScene = preload("res://Scenarios/Aandrisk/AandriskEncounter.tscn")
const HarmagianEncounterScenarioPs : PackedScene = preload("res://Scenarios/Harmagian/HarmagianEncounter.tscn")
const CriminalScenario2Ps : PackedScene = preload("res://Scenarios/Criminal/Criminal.tscn")
const CriminalReturnScenario2Ps : PackedScene = preload("res://Scenarios/CriminalReturn/CriminalReturn.tscn")
const Fulberte1Scenario2Ps : PackedScene = preload("res://Scenarios/Fulberte/1/Fulberte.tscn")
const Fulberte2Scenario2Ps : PackedScene = preload("res://Scenarios/Fulberte/2/Fulberte2.tscn")
const Fulberte3Scenario2Ps : PackedScene = preload("res://Scenarios/Fulberte/3/Fulberte3.tscn")
const Picnic1ScenarioPs : PackedScene = preload("res://Scenarios/Picnic/1/Picnic.tscn")
const Picnic2ScenarioPs : PackedScene = preload("res://Scenarios/Picnic/2/Picnic2.tscn")
const MimicScenarioPs : PackedScene = preload("res://Scenarios/Mimic/Mimic.tscn")

var _scenarios : Array[ScenarioBase] = []

func _ready():
	LoadAllScenarios()

func LoadAllScenarios():
	AddScenarioFromPackedScene(TutoScenarioPs)
	AddScenarioFromPackedScene(CakeStoryScenarioPs)
	AddScenarioFromPackedScene(Alzheimer1ScenarioPs)
	AddScenarioFromPackedScene(Alzheimer2ScenarioPs)
	#AddScenarioFromPackedScene(AandriskEncounterScenarioPs)
	#AddScenarioFromPackedScene(HarmagianEncounterScenarioPs)
	#AddScenarioFromPackedScene(CriminalScenario2Ps)
	#AddScenarioFromPackedScene(CriminalReturnScenario2Ps)
	#AddScenarioFromPackedScene(Fulberte1Scenario2Ps)
	#AddScenarioFromPackedScene(Fulberte2Scenario2Ps)
	#AddScenarioFromPackedScene(Fulberte3Scenario2Ps)
	#AddScenarioFromPackedScene(Picnic1ScenarioPs)
	#AddScenarioFromPackedScene(Picnic2ScenarioPs)
	#AddScenarioFromPackedScene(MimicScenarioPs)

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
