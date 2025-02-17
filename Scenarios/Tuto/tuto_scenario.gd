extends ScenarioBase
class_name TutoScenario

var _startLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _noChangeLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	Id = 1
	AvailabilityCounter = 0
	_state = Enums.ScenarioState.Opening 
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Doctor !"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "What can I do for you ?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I have a problem with an old memory of my brother. !"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "We always had a good relationship and grew up together."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Except on my 170th anniversary where he got into a cyber-rage and slaughtered my psycho-cake."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Hm..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "To this day, I still dream of its hainous gaze and it Pocket-Massacror-3099B splashing cake on the whole party."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I'd like to forget about it and have happy memory to get back my brother."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "It's been 60 years and I still can't look at him normally."))

	# Good ending
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Ah ah ah ! What a nice cream cake battle ! What a memory !"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Thanks doctor, I feel better."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I'm impatient to see my brother again."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Good bye !"))
	
	# Bad ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Teckno damnit ! I messed it up..."))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I'll quicky erase all traces of me."))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Here it is, it never happened"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Probably should wipe my own memories to be safe."))

	# No change ending
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Doctor ! I still feel uneasy with my brother !"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "What did you do or not do ?"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I changed the memory by a less negative one."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But this isn't what I asked for !"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "This is more protective for your identity"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "You'll work the rest out yourself."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I won't pay a lot for a small change, I'll ask someone else."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Take care of yourself."))

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

	var hasHappy = souvenirs[1].tags.find(Enums.MemTag.Happy) >= 0
	if hasHappy:
		_pay = 400
		LoadLines(_goodEndingLines)
	else:
		_pay = 50
		LoadLines(_noChangeLines)
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	var tags = souvenirs[1].tags
	return tags.find(Enums.MemTag.Family) < 0
