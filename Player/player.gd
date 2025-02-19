extends Node
class_name Player

const StartMoney : int = 0
@onready var _scenarioProvider : ScenarioFactory = $ScenarioProvider
@onready var _memoryBank : MemoryBank = $MemoryBank

var _money : int = 10000
var _errors : Array[CharacterBase] = []
var _lastErrorManaged : bool = true

var _hasSeenTuto : bool = false

func ValidateTuto():
	_hasSeenTuto = true

var _savedPersons : int = 0

signal UpdatedMoney(amount : int)
	
func UpdateMoney(amount : int) -> bool:
	if (_money + amount < 0):
		return false
	_money += amount
	if (amount > 0):
		%MoneyGainSound.play()
	UpdatedMoney.emit(_money)
	return true

func GetMoneyAmount() -> int:
	return _money

func Reset() -> void:
	_money = StartMoney
	_errors = []
	_memoryBank.LoadStartingMemory()
	_scenarioProvider.LoadAllScenarios()

func AddError(person : CharacterBase):
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

func StoreFriedPerson(character : CharacterBase):
	_errors.append(character)

func GetCharactersError() -> Array[CharacterBase]:
	return _errors.duplicate()
