extends Node
class_name Player

const StartMoney : int = 0
@onready var _scenarioProvider : ScenarioFactory = $ScenarioProvider
@onready var _memoryBank : MemoryBank = $MemoryBank

var _money : int = 1000
var _errors : Array[String] = []
var _lastErrorManaged : bool = true

signal UpdatedMoney(amount : int)
	
func UpdateMoney(amount : int) -> bool:
	if (_money + amount < 0):
		return false
	_money += amount
	UpdatedMoney.emit(_money)
	return true

func GetMoneyAmount() -> int:
	return _money

func Reset() -> void:
	_money = StartMoney
	_errors = []

func AddError(person : String):
	_errors.append(person)
	_lastErrorManaged = false

func BuyMemory(memories : Array[MemoryData]) -> bool:
	var amount : int = 0
	for memory in memories:
		amount += memory.memory_cost

	if (!UpdateMoney(-amount)):
		return false

	for memory in memories:
		_memoryBank.AddMemory(memory)	
	return true
	
func GetAvailableMemories():
	return _memoryBank.GetCurrentMemories()
		
func GetNextScenario() -> ScenarioBase:
	return _scenarioProvider.GetNextScenario()
