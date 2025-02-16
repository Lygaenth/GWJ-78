extends ScenarioBase
class_name TutoScenario

func _ready():
	Id = 1
	AvailabilityCounter = 0
	_state = Enums.ScenarioState.Opening 
	_lines = []
	# Opening
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Doctor !"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "What can I do for you ?"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I have a problem with an old memory of my brother. !"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "We always had a good relationship and grew up together."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Except on my 170th anniversary where he got into a cyber-rage and slaughtered my psycho-cake."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Hm..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "To this day, I still dream of its hainous gaze and it Pocket-Massacror-3099B splashing cake on the whole party."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I'd like to forget about it and have happy memory to get back my brother."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "It's been 60 years and I still can't look at him normally."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.None, "")) # 9

	# Good ending
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Ah ah ah ! What a nice cream cake battle ! What a memory !"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Thanks doctor, I feel better."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I'm impatient to see my brother again."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Good bye !"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.None, "")) # 14
	
	# Bad ending
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Teckno damnit ! I messed it up..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I'll quicky erase all traces of me."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Here it is, it never happened"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Probably should wipe my own memories to be safe."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.None, "")) # 19

	# No change ending
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Doctor ! I still feel uneasy with my brother !"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "What did you do or not do ?"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I changed the memory by a less negative one."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But this isn't what I asked for !"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "This is more protective for your identity"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "You'll work the rest out yourself."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I won't pay a lot for a small change, I'll ask someone else."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Take care of yourself."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.None, "")) # 28
	
func GetLine() -> DialogLine:
	var dialogLine = _lines[_lineIndex]
	_lineIndex += 1
	if (_lineIndex == 9):
		_state = Enums.ScenarioState.Operation
	
	if _lineIndex == 14 || _lineIndex == 19 || _lineIndex == 28:
		_state = Enums.ScenarioState.Closed
	
	return dialogLine

func ResolveAndCheckIfFried(souvenirs : Array[MemoryData]) -> bool:
	var isFried = _isFried(souvenirs)
	if(isFried):
		ManageFry()
		_lineIndex = 15
		return true

	var hasHappy = souvenirs[1].tags.find(Enums.MemTag.Happy) >= 0
	if hasHappy:
		_pay = 400
		_lineIndex = 10
	else:
		_pay = 50
		_lineIndex = 20
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	var tags = souvenirs[1].tags
	return tags.find(Enums.MemTag.Family) < 0
