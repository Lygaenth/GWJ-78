extends ScenarioBase
class_name HoloBookScenario1

func _ready():
	Id = 3
	AvailabilityCounter = 1
	AvailabilityCondition = true
	_state = Enums.ScenarioState.Opening 
	_lines = []
	# Opening
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I've..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I've seen things I wish to forget"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Did something happened ?"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I was moderator at MetaBooX."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Let's say some people post crazy shits over there..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I see."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "No you don't. I quit my job and I need to repair myself."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Ok..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Erasure of the whole period or just the trauma ?"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Isn't the whole thing better ?"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Depends. It's more expensive and changes you more. I'll see what is best.")) # 8
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Thanks Doc...")) # 13
	
	# Ending Trauma erased
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I feel tired and want to sleep."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I still remember the infinite non-sensical bots, but I feel lighter."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I'm gonna do a whole day nap, thanks."))
	
	# Ending whole job erased
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I don't remember why I'm here, but I guess that means you did your job well."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Maybe I should'nt have left that job."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I feel sleepy, g'night Doc !"))

	# Fried ending
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Poor boy... What did I miss ?"))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Hope a partial reset will work."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I'll remove traces of my intervention..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Then send an anonymous alert at his place."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I'll do better next time."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I'll erase my own memory to stay confident..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "..."))
	_lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Oh, I didn't have patient today. Day passed so fast"))
	
func GetLine() -> DialogLine:
	var dialogLine = _lines[_lineIndex]
	_lineIndex += 1
	if (_lineIndex == 13):
		_state = Enums.ScenarioState.Operation
	
	if _lineIndex == 14 || _lineIndex == 18:
		_state = Enums.ScenarioState.Closed
	
	return dialogLine

func ResolveAndCheckIfFried(memories : Array[MemoryData]) -> bool:
	var isFried = _isFried(memories)
	if(_isFried):
		ManageFry()
		return true
	
	var intermediate1 = memories[1]
	var intermediate2 = memories[2]
	if (memories[1].memory_title == "Working at MetaBooX"): #only trauma erased
		_lineIndex = 14
		_pay = 800
	else: # only trauma erased
		_lineIndex = 18
		_pay = 1000
	_state = Enums.ScenarioState.OperationResult
	UnlockScenario.emit(3)
	_completed = true
	return false

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	return true
