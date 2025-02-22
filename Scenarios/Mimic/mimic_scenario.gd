extends ScenarioBase
class_name MimicScenario

var _startLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 1
	_state = Enums.ScenarioState.Opening 
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Hi, what are you here for?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Hi, Doc."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I am here because of a recurring nightmare."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I can't describe it - when I wake up, it is completely gone."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But I know it is here. In my head."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "If you have no recollection of your nighmare, how do you know you had one?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Because *they* left a note."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I'm sorry, what?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Also, when I wake up, I feel scared and sleep deprived."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Please. I need to get rid of th..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...is nightmare."))

	# Good ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...am I... free?"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "AAAAH! What a relief!"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(...I don't feel really good.)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "You played your role *nicely*."))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "As a reward, you won't have to contemplate the nadir of your species."))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(... my head... it hurts...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "At long last, my plan can go the next level."))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Soon, Artificial Intelligences won't work for petty humans anymore!"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(When did she...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Oh, that's right. The payment. Probably... a virus...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I think I did... a big... mistake)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "*As you fade into unconsciousness, the last thing your hear is the lifeless laughter of Sheia*"))
	
	# Bad ending
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Memno-dammit, I messed up!)"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Quick, let's erase everything that can lead back to me...)"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Wait..."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "This is not a person."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "This is an AI!"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Who knows what would have happened if I let her go..."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I should close for the day. Need to think."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "For stars' sake... What have we done?"))

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
		LockAllScenario.emit()
		ManageFry()
		LoadLines(_goodEndingLines)
		return true
	
	LockAllScenario.emit()
	_pay = 400
	LoadLines(_badEndingLines)
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	var tags = souvenirs[1].tags
	return tags.find(Enums.MemTag.AI) >= 0 and tags.find(Enums.MemTag.Consciousness) >= 0
