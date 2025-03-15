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
var _logs = ""

func _ready():
	_logs+= "loading scenarios\n"
	LoadAllScenarios()

func LoadAllScenarios():
	_logs+= "cleaning scenarios\n"
	for scenar in _scenarios:
		scenar.queue_free()
	_scenarios.clear()
	_logs+= "loading scenario Tuto"
	AddScenarioFromPackedScene(TutoScenarioPs)
	_logs+= "loading scenario Cake story"
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
		if(scenar.IsAvailable()):
			availableScenars.append(scenar)
		if scenar.IsUnlocked():
			hasUnlockedScenarios = true
			scenar.DecrementCounter()
	if (availableScenars.size() == 0):
		if hasUnlockedScenarios:
			return GetNextScenario() # decrement recursively until an available scenario is available
		return null

	return availableScenars.pick_random()

func AddScenarioFromPackedScene(ps : PackedScene):
	var scenar = ps.instantiate() as ScenarioBase
	scenar.UnlockScenario.connect(OnUnlockScenario)
	scenar.LockAllScenario.connect(OnLockAllScenarios)
	add_child(scenar)
	_logs+= "scenario loaded. Line count:"+str(scenar._lines.size())+"\n"
	_scenarios.append(scenar)

func OnUnlockScenario(scenarioId : int):
	for scenario : ScenarioBase in _scenarios:
		if (scenario.Id == scenarioId):
			scenario.Unlock()

func OnLockAllScenarios():
	for scenario in _scenarios:
		scenario.Lock()
