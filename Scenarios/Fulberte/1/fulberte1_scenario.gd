extends ScenarioBase
class_name Fulberte1Scenario

var _startLines : Array[DialogLine] = []
var _forgetFriendsLines : Array[DialogLine] = []
var _forgetLoveLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _noChangeLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 1
	_state = Enums.ScenarioState.Opening 
	
	var dialogsByKeys = DialogLineProvider.GetDialogs("res://Translations/Dialogs/Fulberte/FulberteTranslation.csv" , ["FULBERTE_DIALOG_START", "FULBERTE_DIALOG_FORGETFRIENDS", "FULBERTE_DIALOG_FORGETLOVE", "FULBERTE_DIALOG_NOCHANGE"])

	for line : String in dialogsByKeys["FULBERTE_DIALOG_START"]:
		var talker = GetTalker(line)
		_startLines.append(DialogLineFactory.CreateLine(talker, line))

	for line : String in dialogsByKeys["FULBERTE_DIALOG_FORGETFRIENDS"]:
		var talker = GetTalker(line)
		_forgetFriendsLines.append(DialogLineFactory.CreateLine(talker, line))
	
	for line : String in dialogsByKeys["FULBERTE_DIALOG_FORGETLOVE"]:
		var talker = GetTalker(line)
		_forgetLoveLines.append(DialogLineFactory.CreateLine(talker, line))
	
	for line : String in dialogsByKeys["FULBERTE_DIALOG_NOCHANGE"]:
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

	var loveCount = 0
	var familyCount = 0
	var friendCount = 0
	for s in souvenirs:
		if s.tags.find(Enums.MemTag.Family) >= 0 and s.tags.find(Enums.MemTag.Conflict) < 0:
			familyCount += 1
		elif s.tags.find(Enums.MemTag.Love) >= 0 and s.tags.find(Enums.MemTag.Conflict) < 0:
			loveCount +=1
		elif s.tags.find(Enums.MemTag.Friend) >= 0 and s.tags.find(Enums.MemTag.Conflict) < 0:
			loveCount +=1
	# 2. check tags
	if souvenirs[1].tags.find(Enums.MemTag.LifePath) >= 0 and souvenirs[2].tags.find(Enums.MemTag.LifePath) >= 0:
		_pay = 0
		LoadLines(_noChangeLines)
	else:
		if loveCount < familyCount or loveCount < friendCount:
			_pay = 400
			LoadLines(_forgetLoveLines)
		else:
			_pay = 800
			LoadLines(_forgetFriendsLines)
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	var noFamily = souvenirs[1].tags.find(Enums.MemTag.Family) < 0 and souvenirs[2].tags.find(Enums.MemTag.Family) < 0
	var noFriend = souvenirs[1].tags.find(Enums.MemTag.Friend) < 0 and souvenirs[2].tags.find(Enums.MemTag.Friend) < 0
	var noLove = souvenirs[1].tags.find(Enums.MemTag.Love) < 0 and souvenirs[2].tags.find(Enums.MemTag.Love) < 0
	return (noLove and noFriend and noFamily)
