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
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "We always had a good relationship and grew up together. Except on my 170th anniversary where he got into a cyber-rage and slaughtered my psycho-cake."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Hm."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "To this day, I still dream of its hainous gaze and it Pocket-Massacror-3099B splashing cake on the whole party."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I'd like to forget about it and have a sane relationship with my brother again."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "It's been 60 years and I still can't look at him normally."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.None, "")) # 8

	# Good ending
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Thanks doctor, I feel better"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Good bye !"))

	# BAd E
	
func GetLine() -> DialogLine:
	var dialogLine = _lines[_lineIndex]
	_lineIndex += 1
	if (_lineIndex == 8):
		_state = Enums.ScenarioState.Operation
	
	if _lineIndex == 11:
		_state = Enums.ScenarioState.Closed
	
	return dialogLine

func Resolve(souvenir):
	_state = Enums.ScenarioState.OperationResult
	_pay = 50
	_lineIndex = 9
	_completed = true
