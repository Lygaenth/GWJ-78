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
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Hello, doctor."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "You see, I am using a digiphone right now, but I own another one - an old model."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(...)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "It truly is important to me. It is full of precious memory: pictures of my family, of a college trip on Mars..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(......)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But I cannot remember where I put it."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(.........something is off, she doesn't seem to remember our first voicecall.)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Should I try fixing her memory again? Or do nothing, and send her to a neuroclinic?)"))
	
	# Good ending
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "...you should feel better."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I do, but what about my digiphone?"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I am sorry, I could not locate it. Maybe you lost it without noticing."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Oh? That can't be..."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...I guess it can't be helped. Have a nice day, doctor."))
	
	# Bad ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Memno-dammit, I messed up!"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I gave her something unrelated to friends or family!)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Quick, let's erase everything that can lead back to me...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(There. Never happened.)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I'll erase mine too, just in case...)"))

	# No change ending
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Your memory was damaged. Again. It could be many things, but... I think it is a brain condition."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "What? No... I mean, I have always been light-headed."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I'm afraid not. Light-headedness does not cause this kind of memory damage."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Betelgeuse, that must be a joke!"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Sorry, I am serious."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Can't you do something? Replace the... bad memories by healthy ones?"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "This is beyond the skills of a memory fixer. Actually, you should go to a neuroclinic."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "..."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I can transfer your call to the clinic, if you want?"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...yeah. That'd be nice. Thank you, doctor."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Anything to help. Take care."))
	
	
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
