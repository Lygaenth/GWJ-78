extends Node
class_name Player

const StartMoney : int = 2000
@onready var _money : int = StartMoney
@onready var _scenarioProvider : ScenarioFactory = $ScenarioProvider
@onready var _memoryBank : MemoryBank = $MemoryBank
@onready var ErrorManager: ErrorManager = $ErrorManager

var _scenarioPlayedCount : int = 0
var _shopLock : bool = true
var _shopLocked : bool = true

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
	_hasSeenTuto = false
	_savedPersons = 0
	_memoryBank.LoadStartingMemory()
	_scenarioProvider.LoadAllScenarios()

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
	_scenarioPlayedCount += 1
	return _scenarioProvider.GetNextScenario()

	
func IsConnectLock():
	return _scenarioPlayedCount > 1 && _shopLock
	
func IsShopLock():
	return _shopLocked

func UnlockShop():
	_shopLocked = false
	
func ShopUnlock():
	_shopLock = false
