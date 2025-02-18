extends ScenarioBase
class_name Picnic2Scenario

var _startLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _noChangeLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 1
	_state = Enums.ScenarioState.Opening 
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, ""))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, ""))

	# Good ending
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, ""))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, ""))
	
	# Bad ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Techno-dammit, I messed up!)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Quick, let's erase everything that can lead back to me...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(There. Never happened.)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I should be more cautious from now on.)"))

	# No change ending
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, ""))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, ""))

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

	var hasHappy = souvenirs[1].tags.find(Enums.MemTag.Happy) >= 0
	if hasHappy:
		_pay = 400
		LoadLines(_goodEndingLines)
	else:
		_pay = 50
		LoadLines(_noChangeLines)
	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	var tags = souvenirs[1].tags
	return tags.find(Enums.MemTag.Family) < 0
