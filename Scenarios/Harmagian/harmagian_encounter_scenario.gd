extends ScenarioBase
class_name HarmagianEncounterScenario

var _startLines : Array[DialogLine] = []
var _alienLoveLines : Array[DialogLine] = []
var _alienFearLines : Array[DialogLine] = []
var _alienHateLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 1
	_state = Enums.ScenarioState.Opening 
	
	var dialogsByKeys = DialogLineProvider.GetDialogs("res://Translations/Dialogs/Harmagian/HarmagianTranslation.csv" , ["HARMAGIAN_DIALOG_START", "HARMAGIAN_DIALOG_ALIENLOVE", "HARMAGIAN_DIALOG_ALIENFEAR", "HARMAGIAN_DIALOG_ALIENHATE"])

	for line : String in dialogsByKeys["HARMAGIAN_DIALOG_START"]:
		var talker = GetTalker(line)
		_startLines.append(DialogLineFactory.CreateLine(talker, line))

	for line : String in dialogsByKeys["HARMAGIAN_DIALOG_ALIENLOVE"]:
		var talker = GetTalker(line)
		_alienLoveLines.append(DialogLineFactory.CreateLine(talker, line))
	
	for line : String in dialogsByKeys["HARMAGIAN_DIALOG_ALIENFEAR"]:
		var talker = GetTalker(line)
		_alienFearLines.append(DialogLineFactory.CreateLine(talker, line))
	
	for line : String in dialogsByKeys["HARMAGIAN_DIALOG_ALIENHATE"]:
		var talker = GetTalker(line)
		_alienHateLines.append(DialogLineFactory.CreateLine(talker, line))
	
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
		
	# 1. get tags
	var happyCount = 0
	var unchanged = false
	for s in souvenirs:
		if s.tags.find(Enums.MemTag.Sad) >= 0 and s.tags.find(Enums.MemTag.Alien) >= 0 and s.tags.find(Enums.MemTag.Trauma) >= 0:
			unchanged = true
			break
		if s.tags.find(Enums.MemTag.Happy) >= 0 and s.tags.find(Enums.MemTag.Alien) >= 0:
			happyCount += 1
			
	# 2. check tags
	if unchanged:
		_pay = 0
		LoadLines(_alienHateLines)
	else:
		if happyCount == 3:
			_pay = 1200
			UnlockScenario.emit(ScenarioConst.Aandrisk)
			LoadLines(_alienLoveLines)
		else:
			_pay = 800
			LoadLines(_alienFearLines)

	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	for s in souvenirs:
		if s.tags.find(Enums.MemTag.Alien) < 0 and s.can_be_clicked:
			return true
	return false
