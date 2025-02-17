extends ScenarioBase
class_name HoloBookScenario2

func _ready():
	AvailabilityCounter = 1
	AvailabilityCondition = false
	_state = Enums.ScenarioState.Opening 
	_lines = []
	# Opening
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I've..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I've seen things I wish to forget"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "We've been there before."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Really ? Wasn't that for something else ?"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "You have the same look in your eyes."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Did you make a mistake ?"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I did what you asked."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Can you find another way ?"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Probably. Can you ensure you don't go back to MetaBooX ?"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Dunno, can we overturn capitalism ?"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Probably not now."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "So I can't promise either."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I'll try something else"))

	# Ending Trauma erased
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Do you feel like you could be a moderator for MetaBoox ?"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Nah, not anymore."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I'm relieved."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I hope I won't need you again."))
	
	# Ending whole job erased
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I don't remember why I'm here, but I guess that means you did your job well."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Would you feel like you could be moderator for MetaBooX ?"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Why not ? I heard it pays well ! Great idea."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "See you later"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I feel sleepy, g'night Doc !"))
	
func GetLine() -> DialogLine:
	var dialogLine = _lines[_lineIndex]
	_lineIndex += 1
	if (_lineIndex == 14):
		_state = Enums.ScenarioState.Operation
	
	if _lineIndex == 18 || _lineIndex == 22:
		_state = Enums.ScenarioState.Closed
		if (!_completed):
			_lineIndex = 0
	
	return dialogLine

func Resolve(memories :  Array[MemoryData]):
	var intermediate1 = memories[1]
	var intermediate2 = memories[2]
	if (memories[1].memory_title == "Working at MetaBooX"): #only trauma erased
		_lineIndex = 14
		_pay = 800
		_completed = true
	else: # only trauma erased
		_lineIndex = 18
		_pay = 1000
	_state = Enums.ScenarioState.OperationResult
