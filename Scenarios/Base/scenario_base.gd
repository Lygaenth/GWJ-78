extends Node
class_name ScenarioBase

@export var Patient : CharacterBase
@export var Id : int

var _lineIndex: int = 0
var _lines : Array[DialogLine]
var _state : Enums.ScenarioState
var _pay : int = 50

var AvailabilityCounter : int = 0
var AvailabilityCondition : bool

func UnlockScenario() -> Array[int]:
	return []

func Resolve(souvenir):
	pass

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
