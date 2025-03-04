extends ScenarioBase
class_name MimicScenario

var _startLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 6
	_state = Enums.ScenarioState.Opening 

	var dialogsByKeys = DialogLineProvider.GetDialogs("res://Translations/Dialogs/Mimic/MimicTranslation.csv" , ["MIMIC_DIALOG_START", "MIMIC_DIALOG_GOODENDING", "MIMIC_DIALOG_BADENDING"])

	for line : String in dialogsByKeys["MIMIC_DIALOG_START"]:
		var talker = GetTalker(line)
		_startLines.append(DialogLineFactory.CreateLine(talker, line))

	for line : String in dialogsByKeys["MIMIC_DIALOG_GOODENDING"]:
		var talker = GetTalker(line)
		_goodEndingLines.append(DialogLineFactory.CreateLine(talker, line))
	
	for line : String in dialogsByKeys["MIMIC_DIALOG_BADENDING"]:
		var talker = GetTalker(line)
		_badEndingLines.append(DialogLineFactory.CreateLine(talker, line))
	
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

func ManageFry() -> void: #Not added to error because not human
	_state = Enums.ScenarioState.Frying
	_pay = 0
	_completed = true

func ResolveAndCheckIfFried(souvenirs : Array[MemoryData]) -> bool:
	var isFried = _isFried(souvenirs)
	if(isFried):
		ManageFry()
		LoadLines(_goodEndingLines)
		return true
	
	LockAllScenario.emit()
	PlayerSingleton.ErrorManager.ReleaseAi()
	Patient.Fix()
	_pay = 400
	LoadLines(_badEndingLines)
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	var tags = souvenirs[1].tags
	return tags.find(Enums.MemTag.AI) >= 0 and tags.find(Enums.MemTag.Consciousness) >= 0
