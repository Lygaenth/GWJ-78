extends ScenarioBase
class_name HarmagianEncounterScenario

var _startLines : Array[DialogLine] = []
var _goodEndingLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []
var _noChangeLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 1
	_state = Enums.ScenarioState.Opening 
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Hi doc."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Is that... Glenn Kestrel? The most anti-Sapient speaker of the Threads?!)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Hi, what can I do for you?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Well, doc... I don't like non-human Sapients. To be fair, I used to *hate* them."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But recently, I was 'encouraged' to work with two Aandrisk."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Turns out they are not so bad. They are skilled, hard-working and sharp-tongued, just like me!"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "My hatred of Sapients, I think it boils down to my first encounter with one of them."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "You want me to fix this memory, so you won't hate Sapients anymore?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Yes, exactly. I am sick of playing this stupid role."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I'll do what I can."))
	
	# Good ending
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "So, your thoughts about Harmagians?"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "They are disgusting, with their slick little tentacles!"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...but I don't feel any hate towards them. I feel... compassion for their frail body."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "What about Aandrisks?"))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "They are kind of attractive."))
	_goodEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Glenn Kestrel, non-specist? What a time to be alive!)"))
	
	# Bad ending
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Techno-dammit, I messed up!)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Quick, let's erase everything that can lead back to me...)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(There. Never happened.)"))
	_badEndingLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I should be more cautious from now on.)"))
	
	# No change ending
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "So, your thoughts about Harmagians?"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "They are disgusting, with their slick little tentacles!"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "What about Aandrisks?"))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I don't like them lizards."))
	_noChangeLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Good for me, he did not realize that I did not touch his memory.)"))
	
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
