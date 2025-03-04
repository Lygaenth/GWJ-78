extends ScenarioBase
class_name AandriskEncounterScenario

var _startLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _alienLoveLines : Array[DialogLine] = []
var _neutralEndingLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 2
	_state = Enums.ScenarioState.Opening 
	
	var dialogsByKeys = DialogLineProvider.GetDialogs("res://Translations/Dialogs/Aandrisk/AandriskTranslation.csv" , ["AANDRISK_DIALOG_START", "AANDRISK_DIALOG_GOOD", "AANDRISK_DIALOG_NEUTRAL", "AANDRISK_DIALOG_ALIENLOVE"])

	for line : String in dialogsByKeys["AANDRISK_DIALOG_START"]:
		var talker = GetTalker(line)
		_startLines.append(DialogLineFactory.CreateLine(talker, line))

	for line : String in dialogsByKeys["AANDRISK_DIALOG_GOOD"]:
		var talker = GetTalker(line)
		_goodEndingLines.append(DialogLineFactory.CreateLine(talker, line))
	
	for line : String in dialogsByKeys["AANDRISK_DIALOG_NEUTRAL"]:
		var talker = GetTalker(line)
		_alienLoveLines.append(DialogLineFactory.CreateLine(talker, line))
	
	for line : String in dialogsByKeys["AANDRISK_DIALOG_ALIENLOVE"]:
		var talker = GetTalker(line)
		_neutralEndingLines.append(DialogLineFactory.CreateLine(talker, line))
	
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
	var hasHappy = souvenirs[1].tags.find(Enums.MemTag.Happy) >= 0
	var hasAlien = souvenirs[1].tags.find(Enums.MemTag.Alien) >= 0
	var hasLove = souvenirs[1].tags.find(Enums.MemTag.Love) >= 0
	# 2. check tags
	if hasHappy and !hasAlien:
		_pay = 800
		LoadLines(_goodEndingLines)
	elif hasAlien and hasLove:
		_pay = 0
		LoadLines(_alienLoveLines)
	else:
		_pay = 400
		LoadLines(_neutralEndingLines)
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	var tags = souvenirs[1].tags
	return tags.find(Enums.MemTag.Broken) >= 0
