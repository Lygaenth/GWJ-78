extends ScenarioBase
class_name HoloBookScenario1

var _startLines : Array[DialogLine] = []
var _goodEndingALines : Array[DialogLine] = []
var _goodEndingBLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _noChangeLines : Array[DialogLine] = []

var _isPostOpChat = false

func _ready():
	AvailabilityCounter = 1
	AvailabilityCondition = true
	_state = Enums.ScenarioState.Opening 

	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I've..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I've seen things I wish to forget"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Did something happened ?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I was moderator at MetaBooX."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Let's say some people post crazy shits over there..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I see."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "No you don't. I quit my job and I need to repair myself."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Ok..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Erasure of the whole period or just the trauma ?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Isn't the whole thing better ?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Depends. It's more expensive and changes you more. I'll see what is best.")) # 8
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Thanks Doc...")) # 13
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.None, "")) # 14
	
	# Ending Trauma erased
	_goodEndingALines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I..."))
	_goodEndingALines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I feel tired and want to sleep."))
	_goodEndingALines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I still remember the infinite non-sensical bots, but I feel lighter."))
	_goodEndingALines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I'm gonna do a whole day nap, thanks."))
	_goodEndingALines.append(DialogLineFactory.CreateLine(Enums.Talker.None, "")) # 19
	
	# Ending whole job erased
	_goodEndingBLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I..."))
	_goodEndingBLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I don't remember why I'm here, but I guess that means you did your job well."))
	_goodEndingBLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Maybe I should'nt have left that job."))
	_goodEndingBLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I feel sleepy, g'night Doc !"))
	_goodEndingBLines.append(DialogLineFactory.CreateLine(Enums.Talker.None, "")) # 24
	
	# Fried ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Poor boy... What did I miss ?"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Hope a partial reset will work."))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I'll remove traces of my intervention..."))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Then send an anonymous alert at his place."))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I'll do better next time."))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I'll erase my own memory to stay confident..."))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "..."))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Oh, I didn't have patient today. Day passed so fast"))
	
	LoadLines(_startLines)
	
func GetLine() -> DialogLine:
	var dialogLine = _lines[_lineIndex]
	_lineIndex += 1
	if (_lineIndex < _lines.size()):
		return dialogLine

	if (_isPostOpChat):
		_state = Enums.ScenarioState.Operation
		_isPostOpChat = true
	else:
		_state = Enums.ScenarioState.Closed
	
	return dialogLine

func ResolveAndCheckIfFried(memories : Array[MemoryData]) -> bool:
	var isFried = _isFried(memories)
	if(_isFried):
		ManageFry()
		LoadLines(_badEndingLines)
		return true
	
	var intermediate1 = memories[1]
	var intermediate2 = memories[2]

	if (memories[1].memory_title == "Working at MetaBooX"): #only trauma erased
		LoadLines(_goodEndingALines)
		_pay = 800
		UnlockScenario.emit(ScenarioConst.Metabook2Id)
	else: # only trauma erased
		LoadLines(_goodEndingALines)
		_pay = 1000

	_state = Enums.ScenarioState.OperationResult

	_completed = true
	return false

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	# both intermediary memories must be work related
	var hasWork1 = souvenirs[1].tags.find(Enums.MemTag.Work) >= 0
	var hasWork2 = souvenirs[2].tags.find(Enums.MemTag.Work) >= 0
	return hasWork1 && hasWork2
