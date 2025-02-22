extends Node
class_name ScenarioBase

@export var Patient : CharacterBase
@export var Id : int

var _lineIndex: int = 0
var _lines : Array[DialogLine]
var _state : Enums.ScenarioState
var _pay : int = 50
var _completed : bool = false

@export var Memories : MemoryThread

var AvailabilityCounter : int = 0
var _availabilityCondition : bool = true

signal UnlockScenario(unlockedId : int)
signal LockAllScenario()

func ResolveAndCheckIfFried(_memories : Array[MemoryData]) -> bool:
	_state = Enums.ScenarioState.Closing
	_completed = true
	return false

func IsAvailable() -> bool:
	return !_completed && !_availabilityCondition && AvailabilityCounter == 0

func IsUnlocked() -> bool:
	return !_availabilityCondition && !_completed

func GetPay():
	if (_state == Enums.ScenarioState.OperationResult):
		_state = Enums.ScenarioState.Closing
		return _pay
	else:
		return 0

func GetLine() -> DialogLine:
	return _lines[_lineIndex]

func GetState() -> Enums.ScenarioState:
	return _state

func GetMemories() -> MemoryThread:
	return Memories

func ManageFry() -> void:
	_state = Enums.ScenarioState.Frying
	_pay = 0
	_completed = true
	PlayerSingleton.ErrorManager.AddFriedCharacter(Patient)

func LoadLines(newLines : Array[DialogLine]) -> void:
	_lineIndex=0
	_lines.clear()
	_lines.append_array(newLines)
	
func DecrementCounter():
	if (IsUnlocked() && AvailabilityCounter > 0):
		AvailabilityCounter += -1

func Unlock():
	_availabilityCondition = false

func Lock():
	_completed = true
	_availabilityCondition = true
