extends Node
class_name ScenarioFactory

const CakeStoryScenarioPs : PackedScene = preload("res://Scenarios/ACakeStory/CakeStoryScenario.tscn")
const TutoScenarioPs : PackedScene = preload("res://Scenarios/Tuto/TutoScenario.tscn")
const HoloBookScenario1Ps : PackedScene = preload("res://Scenarios/HoloBookWorker/HoloBookScenario1.tscn")
const HoloBookScenario2Ps : PackedScene = preload("res://Scenarios/HoloBookWorker/Part2/HoloBookScenario2.tscn")

var _scenarios : Array[ScenarioBase] = []

func _ready():
	LoadAllScenarios()

func LoadAllScenarios():
	AddScenarioFromPackedScene(TutoScenarioPs)
	AddScenarioFromPackedScene(CakeStoryScenarioPs)
	AddScenarioFromPackedScene(HoloBookScenario1Ps)
	AddScenarioFromPackedScene(HoloBookScenario2Ps)

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
