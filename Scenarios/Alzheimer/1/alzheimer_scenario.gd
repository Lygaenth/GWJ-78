extends ScenarioBase
class_name AlzheimerScenario

var _startLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _neutralLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 1
	_state = Enums.ScenarioState.Opening 
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Hello, doctor."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Hi. Please tell me about your problem."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Thank you. You see, I am using a scrib, but I own another one - an old model."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I have precious memory on that scrib. Pictures of my family, of a college trip on Mars..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But no matter how much I try, I cannot remember the password!"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Why not getting a tech to unblock your scrib?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "There is no tech in my neighborhood. Besides, you're cheaper."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Cheaper than fixing a scrib? I doubt it. Well, she must have reasons.)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Ok, I'll see what I can do. Put a slap patch on your temple."))

	# Good ending
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "How you feeling?"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "A lot better, but what about my password?"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I think it's 'fireshrimp'."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Oh? Let me try..."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...it works!!! Thank you so much. Have a good day."))
	
	# Bad ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Techno-dammit, I messed up!)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Quick, let's erase everything that can lead back to me...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(There. Never happened.)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I should be more cautious from now on.)"))

	# No change ending
	_neutralLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I got your password. It's 'fireshrimp'."))
	_neutralLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Oh? Let me try..."))
	_neutralLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...it works!!! Thank you so much. Have a good day."))
	
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

	var hasEmpty = souvenirs[1].tags.find(Enums.MemTag.Empty) >= 0
	if hasEmpty:
		_pay = 200
		LoadLines(_neutralLines)
	else:
		_pay = 400
		LoadLines(_goodEndingLines)
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	var tags = souvenirs[1].tags
	return tags.find(Enums.MemTag.Family or Enums.MemTag.Love or Enums.MemTag.Friend) < 0
