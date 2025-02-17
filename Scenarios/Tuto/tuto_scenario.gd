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
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "... ... ..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Hi, what can I do for you?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Hi. My name is... A..ma..no? Someone told me to call this... voicemail?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Is that... Memory corruption ?)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Alright, let me ask you a few questions."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Does your memory feel \"fuzzy\"?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Having trouble learning new information?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Not knowing exactly where you are?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "How do you know?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Partly because of the headjack on your occipital bone."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "But mostly because this is my job. I am a memory fixer."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Ok, next question. What is the last thing you remember before waking up?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I was in a... bar... and then I... Sorry, I can't remember. It's all..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Fuzzy, right?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(He was probably robbed by someone at this bar.)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(They hijacked his memory to cover their tracks.)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(But they ended up damaging it)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "M. Amano, right? Let me help you. First, I want you to connect your scrib to your headjack."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Ok... done."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Great. Now, I will gently introduce myself into your memories."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "First, I will look for a DAMAGED MEMORY slot and ERASE it."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Then, I will select the resulting EMPTY MEMORY slot and IMPLANT a new memory into it."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Does it... hurt?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Don't worry, it is absolutely painless."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(well, as long as I don't implant an incoherent memory..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Are you ready?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Yes, I am ready."))
	
	# Drunk ending
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...a friend?"))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Yes, surely you can think of someone, can you?"))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "They bought you a drink, which led to another... and before you knew it, you got drunk!"))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I-I think you are right. I remember meeting... Vahn at... Lizzie's."))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I bet Vahn likes a good bottle of wham, don't they?"))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Yes. I like wham, too."))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "See? Anyways, you should go home. It will probably pass after a good rest."))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "This time it's for free."))
	_drunkEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "But next time you want me to fix your memory, you better come back with credits, okay?"))
	
	# Thief ending
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Oh, stars! How come I don't remember?"))
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "They probably drugged you at some point. You should not accept drinks from strangers."))
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I feel... miserable."))
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Sorry to hear that. Any persistent sense of \"fuzzyness\"?"))
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Yes... what should I do?"))
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "You should probably go home and get some rest. If the symptoms persist until tomorrow, you can come back. With credits."))
	_thiefEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I... will. Goodbye, doctor."))
	
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
