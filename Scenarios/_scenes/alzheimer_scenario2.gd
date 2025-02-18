extends ScenarioBase
class_name AlzheimerScenario2

var _startLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _noChangeLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 1
	_state = Enums.ScenarioState.Opening 
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "M Prima? What's the matter?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Hello, doctor."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "You see, I am using a scrib right now, but I own another one - an old model."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(...)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "It truly is important to me. It is full of precious memory: pictures of my family, of a college trip on Mars..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(......)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But I cannot remember where I put it."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(.........something is off.)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Should I try fixing her memory again? Or do nothing, and send her to a neuroclinic?)"))
	
	# Good ending
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "...you should feel better."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I do, but what about my scrib?"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I am sorry, I could not locate it. Maybe you lost it without noticing."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Oh? That can't be..."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...I guess it can't be helped. Have a nice day, doctor."))
	
	# Bad ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Techno-dammit, I messed up!)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Quick, let's erase everything that can lead back to me...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(There. Never happened.)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I should be more cautious from now on.)"))

	# No change ending
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Listen. Your memory was damaged. It could be many things, but... I think it could be a brain condition."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Oh, stars!"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "This is beyond my skills as a memory fixer. But maybe they can help you at the neuroclinic?"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I will. Thank you, doctor."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Take care M Prima."))
	
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
