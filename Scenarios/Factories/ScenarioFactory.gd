extends Node
class_name ScenarioFactory

const TutoScenarioPs : PackedScene = preload("res://Scenarios/Tuto/TutoScenario.tscn")
const CakeStoryScenarioPs : PackedScene = preload("res://Scenarios/CakeStory/CakeStoryScenario.tscn")
const Alzheimer1ScenarioPs : PackedScene = preload("res://Scenarios/Alzheimer/1/AlzheimerScenario.tscn")
const Alzheimer2ScenarioPs : PackedScene = preload("res://Scenarios/Alzheimer/2/AlzheimerScenario2.tscn")
const AandriskEncounterScenarioPs : PackedScene = preload("res://Scenarios/Aandrisk/AandriskEncounter.tscn")
const HarmagianEncounterScenarioPs : PackedScene = preload("res://Scenarios/Harmagian/HarmagianEncounter.tscn")
const CriminalScenarioPs : PackedScene = preload("res://Scenarios/Criminal/Criminal.tscn")
const Fulberte1ScenarioPs : PackedScene = preload("res://Scenarios/Fulberte/1/Fulberte.tscn")
const Picnic1ScenarioPs : PackedScene = preload("res://Scenarios/Picnic/1/Picnic.tscn")
const Picnic2ScenarioPs : PackedScene = preload("res://Scenarios/Picnic/2/Picnic2.tscn")
const MimicScenarioPs : PackedScene = preload("res://Scenarios/Mimic/Mimic.tscn")

var _scenarios : Array[ScenarioBase] = []

func _ready():
	LoadAllScenarios()

func LoadAllScenarios():
	for scenar in _scenarios:
		scenar.queue_free()
	_scenarios.clear()
	AddScenarioFromPackedScene(TutoScenarioPs, true)
	AddScenarioFromPackedScene(CakeStoryScenarioPs)
	AddScenarioFromPackedScene(Alzheimer1ScenarioPs)
	AddScenarioFromPackedScene(Alzheimer2ScenarioPs)
	AddScenarioFromPackedScene(AandriskEncounterScenarioPs)
	AddScenarioFromPackedScene(HarmagianEncounterScenarioPs)
	AddScenarioFromPackedScene(CriminalScenarioPs)
	AddScenarioFromPackedScene(Fulberte1ScenarioPs)
	AddScenarioFromPackedScene(Picnic1ScenarioPs)
	AddScenarioFromPackedScene(Picnic2ScenarioPs)
	AddScenarioFromPackedScene(MimicScenarioPs)

func ResetScenario():
	LoadAllScenarios()

func GetNextScenario() -> ScenarioBase:
	var hasUnlockedScenarios = false
	var availableScenars : Array[ScenarioBase] = []
	for scenar : ScenarioBase in _scenarios:
		scenar.DecrementCounter()
		if scenar.IsUnlocked():
			hasUnlockedScenarios = true
		if(scenar.IsAvailable()):
			availableScenars.append(scenar)
	if (availableScenars.size() == 0):
		if hasUnlockedScenarios:
			return GetNextScenario() # decrement recursively until an available scenario is available
		return null

	return availableScenars.pick_random()

func AddScenarioFromPackedScene(ps : PackedScene, isAvailable: bool = false):
	var scenar = ps.instantiate() as ScenarioBase
	scenar.UnlockScenario.connect(OnUnlockScenario)
	scenar.LockAllScenario.connect(OnLockAllScenarios)
	add_child(scenar)
	scenar.AvailabilityCondition = isAvailable
	_scenarios.append(scenar)

func OnUnlockScenario(scenarioId : int):
	for scenario in _scenarios:
		if (scenario.Id == scenarioId):
			scenario.AvailabilityCondition = true

func OnLockAllScenarios():
	for scenario in _scenarios:
		scenario.AvailabilityCondition = false
