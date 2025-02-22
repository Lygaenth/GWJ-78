extends ScenarioBase
class_name CriminalScenario

var _startLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _noChangeLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 1
	_state = Enums.ScenarioState.Opening 
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Wait, who are you?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Relax, doc... You can call me Le Douc."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Now listen carefully..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I need a single memory to be erased before the cops catch me:"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "The memory of me selling a corporal kit to a client."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Corporal kits? Human bodies, stolen away to be used as a receptacle for an AI!)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I'll give you $1500, and $1500 when you put it back."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(That's illegal even outside of the Galactic Union! I must refuse...)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Don't go thinking you have a choice. I know where you live."))

	# Good ending
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "My birdies were right: doc, you rock..."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Now. I don't remember what you extracted, but my friends know, and I *will* come back for it."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Til we meet again."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(What should I do?)"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(If I dispose of it, Le Douc will come back for me...)"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(If I keep it, I might go to galactic jail!)"))
	
	# Bad ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Memno-dammit, I messed up!)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(It was the right call.)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I should erase my memory of this incident.)"))

	# No change ending
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Did you make a mistake, doc?"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Try one more time. RIGHT. NOW."))

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

	var isIllegal = souvenirs[1].tags.find(Enums.MemTag.Illegal) >= 0
	
	if isIllegal:
		LoadLines(_noChangeLines)
		_dialogBlock = 0
		_state = Enums.ScenarioState.Opening
		return false
	else:
		_pay = 1500
		UnlockScenario.emit(128)
		LoadLines(_goodEndingLines)
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	var tags = souvenirs[1].tags
	return tags.find(Enums.MemTag.Broken) >= 0
