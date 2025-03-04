extends ScenarioBase
class_name AlzheimerScenario2

var _startLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _noChangeLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 2
	_state = Enums.ScenarioState.Opening 

	var dialogsByKeys = DialogLineProvider.GetDialogs("res://Translations/Dialogs/Alzheimer/Alzheimer2Translation.csv" , ["ALZHEIMER2_DIALOG_START", "ALZHEIMER2_DIALOG_GOOD", "ALZHEIMER2_DIALOG_NOCHANGE"])

	for line : String in dialogsByKeys["ALZHEIMER2_DIALOG_START"]:
		var talker = GetTalker(line)
		_startLines.append(DialogLineFactory.CreateLine(talker, line))

	for line : String in dialogsByKeys["ALZHEIMER2_DIALOG_GOOD"]:
		var talker = GetTalker(line)
		_goodEndingLines.append(DialogLineFactory.CreateLine(talker, line))
	
	for line : String in dialogsByKeys["ALZHEIMER2_DIALOG_NOCHANGE"]:
		var talker = GetTalker(line)
		_noChangeLines.append(DialogLineFactory.CreateLine(talker, line))
	
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
	var isFried = _isFried(souvenirs)
	if(isFried):
		ManageFry()
		LoadLines(PlayerSingleton.ErrorManager.GetErrorDialog())
		return true

	var hasHappy = souvenirs[1].tags.find(Enums.MemTag.Happy) >= 0
	if hasHappy:
		_pay = 800
		LoadLines(_goodEndingLines)
	else:
		_pay = 400
		LoadLines(_noChangeLines)
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	var hasFriend = souvenirs[1].tags.find(Enums.MemTag.Friend) >= 0
	var hasFamily = souvenirs[1].tags.find(Enums.MemTag.Family) >= 0
	var hasLove = souvenirs[1].tags.find(Enums.MemTag.Love) >= 0
	var hasGroup = souvenirs[1].tags.find(Enums.MemTag.Group) >= 0
	return !(hasFriend or hasFamily or hasLove or hasGroup)
