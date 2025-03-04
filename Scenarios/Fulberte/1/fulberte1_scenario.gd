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
	
	var dialogsByKeys = DialogLineProvider.GetDialogs("res://Translations/Dialogs/Aandrisk/AandriskTranslation.csv" , ["FULBERTE_DIALOG_START", "FULBERTE_DIALOG_FORGETFRIENDS", "FULBERTE_DIALOG_FORGETLOVE", "FULBERTE_DIALOG_NOCHANGE"])

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
	
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Hello. I've heard that you could... *change* some of my memories?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "That's right. First time?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Don't worry, we've all been there. What memory do you want to change?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "You see, I have been a Devotee of Gaia for all my life."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Trying to restore our wounded Earth with my devotee friends..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But a couple of years ago, I bumped into a young astronaut and I fell in love."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I ran away with them. Got a new haircut, tried Hyper-Paprika for the first time..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I had the best time of my life!"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But sometimes, I think about my former friends... they were like family."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Can you help me overcome my regrets?"))

	# Forget her friends
	_forgetFriendsLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...I feel relieved. As if an heavy weight was gone."))
	_forgetFriendsLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Now, if you'll excuse me... Life is short, and I don't want to spend another minute away from my love."))
	
	# Forget her love
	_forgetLoveLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...I feel empty. What happened?"))
	_forgetLoveLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Are you alright?"))
	_forgetLoveLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I'm not sure. I'm not *hurt*, but it's like... as if... there was a hole in my chest."))
	_forgetLoveLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I must leave now. I want to see my family."))
	
	# Bad ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Memno-dammit, I messed up!)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Quick, let's erase everything that can lead back to me...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(There. Never happened.)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I should be more cautious from now on.)"))

	# No change ending
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "So, you choose not to erase anything. Why?"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I think your regrets are part of your story. You should value them, too"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "They help you make the right choices. They make you a better person."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Indeed..."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "..."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...I cannot pay you for nothing, but I get it now. Thank you, doctor."))

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
