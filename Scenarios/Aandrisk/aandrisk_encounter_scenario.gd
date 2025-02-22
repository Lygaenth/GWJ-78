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
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Finally! I have been waiting for DECADES!"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Sorry, what can I do for you?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Today, I sent one of my poor employees to a memory fixer..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(...could it be *this* customer from earlier?)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...but when he came back, Glenn was in love with aliens!"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(By the Cosmic Amnesic, it's Glenn Kestrel!)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I saw him k-k-kissing with a Varanid..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Oh, boy...)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "My precious memories were soiled! *Do* something!"))

	# Good ending
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Aaah~ I feel so much better!"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "It truly was a stellar idea."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...if I didn't have to wait, it would have been perfect."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Anyways, I have to go. My time is precious."))
		
	# Bad ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Memno-dammit, I messed up!)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Quick, let's erase everything that can lead back to me...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(There. Never happened.)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I should be more cautious from now on.)"))
	
	# Neutral ending
	_neutralEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Not a great memory... but it'll do."))
	_neutralEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Wait, only $400?"))
	_neutralEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Half the investment, half the cash prize."))
	_neutralEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I have to go now. My time is precious."))
	
	# Alien love ending
	_alienLoveLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Dear stars, what an *horrendous* memory!"))
	_alienLoveLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "And *you* call yourself a memory fixer?"))
	_alienLoveLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I refuse to pay!"))

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
		LoadLines(_badEndingLines)
		return true
	
	# 1. get tags
	var hasHappy = souvenirs[1].tags.find(Enums.MemTag.Happy) >= 0
	var hasAlien = souvenirs[1].tags.find(Enums.MemTag.Alien) >= 0
	var hasLove = souvenirs[1].tags.find(Enums.MemTag.Love) >= 0
	# 2. check tags
	if hasHappy and !hasAlien:
		_pay = 1000
		LoadLines(_goodEndingLines)
	elif hasAlien and hasLove:
		_pay = 0
		LoadLines(_alienLoveLines)
	else:
		_pay = 300
		LoadLines(_neutralEndingLines)
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	var tags = souvenirs[1].tags
	return tags.find(Enums.MemTag.Broken) >= 0
