extends Node
class_name ScenarioFactory

const TutoScenarioPs : PackedScene = preload("res://Scenarios/Tuto/TutoScenario.tscn")

var _scenarios : Array[ScenarioBase] = []

func _ready():
	LoadAllScenarios()

func LoadAllScenarios():
	var tuto = TutoScenarioPs.instantiate() as ScenarioBase
	add_child(tuto)
	_scenarios.append(tuto)


func ResetScenario():
	LoadAllScenarios()

func GetNextScenario() -> ScenarioBase:
	var availableScenars : Array[ScenarioBase] = []
	for scenar in _scenarios:
		if(scenar.IsAvailable()):
			availableScenars.append(scenar)
			
	return availableScenars.pick_random()
