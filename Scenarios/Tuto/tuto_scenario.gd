extends ScenarioBase
class_name TutoScenario

var _startLines : Array[DialogLine] = []
var _drunkEndingLines : Array[DialogLine] = []
var _thiefEndingLines : Array[DialogLine] = []
var _noChangeLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	Id = 1
	AvailabilityCounter = 0
	_availabilityCondition = false
	_state = Enums.ScenarioState.Opening 
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "TUTO_DIALOG_START_LINE_0_PATIENT"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_1_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_2_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_3_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_4_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "TUTO_DIALOG_START_LINE_5_PATIENT"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_6_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_7_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_8_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "TUTO_DIALOG_START_LINE_9_PATIENT"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_10_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_11_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_12_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_13_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_14_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "TUTO_DIALOG_START_LINE_15_PATIENT"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_16_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_17_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_START_LINE_18_DOCTOR"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "TUTO_DIALOG_START_LINE_19_PATIENT"))
	
	# Drunk ending
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "TUTO_DIALOG_DRUNK_LINE_0_PATIENT"))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_DRUNK_LINE_1_DOCTOR"))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "TUTO_DIALOG_DRUNK_LINE_2_PATIENT"))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_DRUNK_LINE_3_DOCTOR"))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_DRUNK_LINE_4_DOCTOR"))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_DRUNK_LINE_5_DOCTOR"))
	
	# Thief ending
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "TUTO_DIALOG_THIEF_LINE_0_PATIENT"))
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_THIEF_LINE_1_DOCTOR"))
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_THIEF_LINE_2_DOCTOR"))
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "TUTO_DIALOG_THIEF_LINE_3_DOCTOR"))
	
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
