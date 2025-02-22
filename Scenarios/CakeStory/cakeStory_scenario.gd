extends ScenarioBase
class_name CakeStoryScenario

var _startLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _noChangeLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 1
	_state = Enums.ScenarioState.Opening 
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Hi, what can I do for you?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Well... It's about my brother."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "We grew up together on a commercial ship. As far as I remember, we had a close relationship."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But on my 16th birthday, he drank too much kick and suddenly started to DESTROY my cake!"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I remember him laughing, splashing cream and strawberry jam on the whole party."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Classic chilhood memory)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I want you to fix this memory, so we can patch things up with my brother."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...it's been 35 years and I couldn't find it in me to forgive him."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Alright, let's fix your relationship. Stuck a slap patch on your temple, and we'll get started."))

	# Good ending
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "AH AH AH! What a nice cream cake battle!"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Thank you Doctor. I feel much better. Can't wait to see him."))
	
	# Bad ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Memno-dammit! I was supposed to implant a family memory!)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Quick, let's erase everything that can lead back to me...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(There. Never happened.)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Just in case, I'll erase mine too...)"))

	# No change ending
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Why am I still feeling uneasy about my brother?"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I replaced your traumatic experience with a more 'neutral' memory."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "You were supposed to get rid of my bad feelings!"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Well, I did my best to preserve your identity."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "...but I am sure you can work it out with your brother, can't you?"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "This ain't what I paid for. I want a discount."))

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
