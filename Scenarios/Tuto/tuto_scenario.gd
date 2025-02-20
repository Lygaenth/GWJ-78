extends ScenarioBase
class_name TutoScenario

var _startLines : Array[DialogLine] = []
var _drunkEndingLines : Array[DialogLine] = []
var _thiefEndingLines : Array[DialogLine] = []
var _noChangeLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	Id = 1
	AvailabilityCounter = 0
	_state = Enums.ScenarioState.Opening 
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Hi, what can I do for you?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "... ... ..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Hi. My name is... A..ma..no?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Is that... Memory corruption ?)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Alright, let me ask you a few questions, okay?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Does your memory feel \"fuzzy\"?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Not knowing exactly where you are?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Having trouble learning new information?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "How do you know?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Partly because of the headjack on your occipital bone..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "...but mostly because this is my job. I am a [MEMORY FIXER]."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Ok, next question. What is the last thing you remember?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I was in a... bar... The barman told me to call you."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(He was probably robbed by someone at this bar.)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(They hijacked his memory to cover their tracks...)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(...but they ended up damaging it)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Alright, I will help you."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "First, I want you to connect your scrib to your headjack."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Great. Now, I will gently introduce myself into your memories."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "First, I will look for a [DAMAGED MEMORY] slot and [ERASE] it."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Then, I will select the resulting [EMPTY MEMORY] slot and [IMPLANT] a new memory into it."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Does it... hurt?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Don't worry, it is absolutely painless."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(well, as long as I don't implant an incoherent memory..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Are you ready?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Yes, I am ready."))
	
	# Drunk ending
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I met with ...a friend?"))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Yes, surely you can think of someone?"))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I-I think you are right. I remember meeting... Vahn at... Lizzie's."))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I bet Vahn likes a good bottle of sintalin, don't they?"))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Yes. I like sintalin, too."))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "See? Anyways, you should go home. It will probably pass after a good rest."))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "This time it's for free, but next time you better come with credits, okay?"))
	
	# Thief ending
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I was robbed? Oh, stars! How come I don't remember?"))
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "They probably used your headjack as an entry point your memory."))
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "You should be fine now. You should probably go home and get some rest."))
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "If the symptoms persist until tomorrow, you can come back. With credits."))
	
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
	var hasDrunk = souvenirs[1].tags.find(Enums.MemTag.Consciousness) >= 0
	_pay = 0
	if hasDrunk:
		LoadLines(_drunkEndingLines)
	else:
		LoadLines(_thiefEndingLines)
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return false

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	return false
