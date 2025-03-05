extends ScenarioBase
class_name Picnic2Scenario

var _startLines : Array[DialogLine] = []
var _traumaErasedLines : Array[DialogLine] = []
var _allJobErasedLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 1
	_state = Enums.ScenarioState.Opening 
	
	var dialogsByKeys = DialogLineProvider.GetDialogs("res://Translations/Dialogs/Picnic/Picnic2Translation.csv" , ["PICNIC2_DIALOG_START", "PICNIC2_DIALOG_GOODENDING", "PICNIC2_DIALOG_ERASEDTRAUMA", "PICNIC2_DIALOG_JOBERASED"])

	for line : String in dialogsByKeys["PICNIC2_DIALOG_START"]:
		var talker = GetTalker(line)
		_startLines.append(DialogLineFactory.CreateLine(talker, line))

	for line : String in dialogsByKeys["PICNIC2_DIALOG_GOODENDING"]:
		var talker = GetTalker(line)
		_goodEndingLines.append(DialogLineFactory.CreateLine(talker, line))
	
	for line : String in dialogsByKeys["PICNIC2_DIALOG_ERASEDTRAUMA"]:
		var talker = GetTalker(line)
		_traumaErasedLines.append(DialogLineFactory.CreateLine(talker, line))
	
	for line : String in dialogsByKeys["PICNIC2_DIALOG_JOBERASED"]:
		var talker = GetTalker(line)
		_allJobErasedLines.append(DialogLineFactory.CreateLine(talker, line))
		
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

	var hasJob = souvenirs[1].tags.find(Enums.MemTag.Work) >= 0 or souvenirs[2].tags.find(Enums.MemTag.Work) >= 0 
	var hasNewJob = hasJob and souvenirs[1].tags.find(Enums.MemTag.Confidence) >= 0 or souvenirs[2].tags.find(Enums.MemTag.Confidence) >= 0
	var jobSucks = hasJob and souvenirs[1].tags.find(Enums.MemTag.Sad) >= 0 or souvenirs[2].tags.find(Enums.MemTag.Sad) >= 0
	if hasNewJob:
		_pay = 400
		LoadLines(_goodEndingLines)
	elif hasJob:
		_pay = 400
		LoadLines(_traumaErasedLines)
	else:
		_pay = 800
		LoadLines(_allJobErasedLines)
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	var hasTrauma = souvenirs[1].tags.find(Enums.MemTag.Trauma) >= 0 or souvenirs[2].tags.find(Enums.MemTag.Trauma) >= 0
	var hasWork = souvenirs[1].tags.find(Enums.MemTag.Work) >= 0 or souvenirs[2].tags.find(Enums.MemTag.Work) >= 0
	return (hasTrauma and !hasWork)
