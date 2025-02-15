extends Node
class_name ScenarioFactory

const TutoScenarioPs : PackedScene = preload("res://Scenarios/Tuto/TutoScenario.tscn")

func GetNextScenario() -> ScenarioBase:
	var scenar = TutoScenarioPs.instantiate() as ScenarioBase
	add_child(scenar)
	return scenar
