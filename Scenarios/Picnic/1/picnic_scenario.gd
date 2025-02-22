extends ScenarioBase
class_name PicnicScenario

var _startLines : Array[DialogLine] = []
var _traumaErasedLines : Array[DialogLine] = []
var _allJobErasedLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 1
	_state = Enums.ScenarioState.Opening 
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Hi, doc. I've..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I've seen things I want to forget."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Did something happen?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "You could say that. Until last tenday, I worked as a moderator on Picnic. You know, the social feed."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Let's say some people post crazy stuff."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I see."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "No you don't. At some point i *had* to quit my job. Stars, I even quit going on the Linkings!"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Say no more..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Erasure of the whole period, or just the trauma ?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Isn't the whole thing better ?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Depends. It's more expensive and changes you more.")) # 8
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Please, do what is best, doc. I just... I need to repair myself.")) # 13
	
	# Ending Trauma erased
	_traumaErasedLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I..."))
	_traumaErasedLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...feel like I could sleep the whole day."))
	_traumaErasedLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I still remember the infinite non-sensical bots..."))
	_traumaErasedLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But I feel lighter. Thank you, doc."))
	
	# Ending whole job erased
	_allJobErasedLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I..."))
	_allJobErasedLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I don't remember why I'm here, but I guess that means you did your job well."))
	_allJobErasedLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I feel exhausted, but I'll rest tomorrow."))
	_allJobErasedLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I need to find a job."))
	_allJobErasedLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...need... job."))
	
	# Good ending
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I..."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...feel like I could sleep the whole day."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But I feel lighter. And I know what I want to do."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Thank you, doc!"))
	
	# Bad ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Techno-dammit, I messed up!)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Quick, let's erase everything that can lead back to me...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(There. Never happened.)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I should be more cautious from now on.)"))

	
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

	var hasJob = souvenirs[1].tags.find(Enums.MemTag.Work) >= 0 or souvenirs[2].tags.find(Enums.MemTag.Work) >= 0 
	var hasNewJob = hasJob and souvenirs[1].tags.find(Enums.MemTag.Confidence) >= 0 or souvenirs[2].tags.find(Enums.MemTag.Confidence) >= 0
	if hasNewJob:
		_pay = 400
		LoadLines(_goodEndingLines)
	elif hasJob:
		_pay = 400
		UnlockScenario.emit(ScenarioConst.Picnic2)
		LoadLines(_traumaErasedLines)
	else:
		_pay = 800
		UnlockScenario.emit(ScenarioConst.Picnic2)
		LoadLines(_allJobErasedLines)
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	var hasTrauma = souvenirs[1].tags.find(Enums.MemTag.Trauma) >= 0 or souvenirs[2].tags.find(Enums.MemTag.Trauma) >= 0
	return (hasTrauma)
