extends ScenarioBase
class_name AlzheimerScenario

var _startLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _noChangeLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 1
	_state = Enums.ScenarioState.Opening 
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Hi. Please tell me about your problem."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Thank you. You see, I am using a digiphone, but I own another one - an old model."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I have precious memory on that scrib. Pictures of my family, of a college trip on Mars..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But no matter how much I try, I cannot remember the password!"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Ok, I'll see what I can do. Put a slap patch on your temple."))

	# Good ending
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "How you feeling?"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "A lot better, but what about my password?"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I think it's 'moonwhale'."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Oh? Let me try..."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...it works!!! Thank you so much. Have a good day."))
	
	# Bad ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Memno-dammit, I gave her a broken memory!)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Quick, let's erase everything that can lead back to me...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(There. Never happened.)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I'll erase mine too, just in case...)"))

	# No change ending
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I got your password. It's 'moonwhale'."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Oh? Let me try..."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...it works!!! Thank you so much. Have a good day."))
	
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
		_pay = 800
		UnlockScenario.emit(ScenarioConst.Alzheimer2)
		LoadLines(_goodEndingLines)
	else:
		_pay = 400
		UnlockScenario.emit(8)
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
