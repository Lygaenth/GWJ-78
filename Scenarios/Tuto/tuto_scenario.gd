extends ScenarioBase
class_name TutoScenario

var _startLines : Array[DialogLine] = []
var _drunkEndingLines : Array[DialogLine] = []
var _thiefEndingLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	Id = 1
	AvailabilityCounter = 0
	_availabilityCondition = false
	_state = Enums.ScenarioState.Opening 
	var dialogsByKeys = DialogLineProvider.GetDialogs("res://Translations/Dialogs/Tuto/TutoTranslation.txt" , ["TUTO_DIALOG_START", "TUTO_DIALOG_DRUNK", "TUTO_DIALOG_THIEF"])

	for line : String in dialogsByKeys["TUTO_DIALOG_START"]:
		var talker = GetTalker(line)
		_startLines.append(DialogLineFactory.CreateLine(talker, line))

	for line : String in dialogsByKeys["TUTO_DIALOG_DRUNK"]:
		var talker = GetTalker(line)
		_drunkEndingLines.append(DialogLineFactory.CreateLine(talker, line))
	
	for line : String in dialogsByKeys["TUTO_DIALOG_THIEF"]:
		var talker = GetTalker(line)
		_thiefEndingLines.append(DialogLineFactory.CreateLine(talker, line))
	
	LoadLines(_startLines)
	
func GetLine() -> DialogLine:
	var dialogLine = _lines[_lineIndex]
	_lineIndex += 1
	if (_lineIndex < _lines.size()):
		return dialogLine
		
	if (_dialogBlock == 0):
		_state = Enums.ScenarioState.Operation
		_dialogBlock = 1
	else:
		_state = Enums.ScenarioState.Closed
	
	return dialogLine

func ResolveAndCheckIfFried(souvenirs : Array[MemoryData]) -> bool:
	var hasDrunk = souvenirs[1].tags.find(Enums.MemTag.Consciousness) >= 0
	_pay = 0
	if hasDrunk:
		LoadLines(_drunkEndingLines)
	else:
		LoadLines(_thiefEndingLines)

	UnlockScenario.emit(ScenarioConst.CakeId)
	UnlockScenario.emit(ScenarioConst.Alzheimer1)
	UnlockScenario.emit(ScenarioConst.Picnic1)
	UnlockScenario.emit(ScenarioConst.Harmagian)
	UnlockScenario.emit(ScenarioConst.Criminal)
	UnlockScenario.emit(ScenarioConst.Fulberte)
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return false

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	return false
