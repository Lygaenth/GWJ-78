extends ScenarioBase
class_name HarmagianEncounterScenario

var _startLines : Array[DialogLine] = []
var _alienLoveLines : Array[DialogLine] = []
var _alienFearLines : Array[DialogLine] = []
var _alienHateLines : Array[DialogLine] = []
var _badEndingLines : Array[DialogLine] = []

var _dialogBlock = 0

func _ready():
	AvailabilityCounter = 1
	_state = Enums.ScenarioState.Opening 
	
	# Opening
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Hi doc."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Isn't that... Glenn Kestrel, the famous journalist from Mars-Reports?!)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Hi, what brings you here today?"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Well, I guess it's all the aliens' fault again..."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I remember now... his show is not very friendly towards aliens)"))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Recently, I was humiliated by an Helicoid merchant... Damned talking snails."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "But since that *incident*, my... animosity has become a liability."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "My superior wants my memory fixed. 'For public image', she said."))
	_startLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Anything for the news, I guess. Put a patch on, I'll get started."))
	
	# Alien love ending
	_alienLoveLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Tell me now: what do you think of Helicoids?"))
	_alienLoveLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "They are disgusting with their little tentacles... but I admire their technology"))
	_alienLoveLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "What about Varanids?"))
	_alienLoveLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Actually, they look kinda hot."))
	_alienLoveLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Ok, maybe I went too far...)"))
	_alienLoveLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Anyways, I feel great. Thanks, doc!"))
	
	# Alien fear ending
	_alienFearLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Tell me now: what do you think of Helicoids?"))
	_alienFearLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "They are so disgusting with all their little tentacles. Gross."))
	_alienFearLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "What about Varanids?"))
	_alienFearLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Those pesky lizards? Always acting like they're superior to us."))
	_alienFearLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Still as species as ever)"))
	_alienFearLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "...but I feel a little more composed. I don't know what you fixed, but you did it."))
	_alienFearLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Thanks, doc!"))
	
	# Alien hate ending
	_alienHateLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Wait... why did you not erase this memory?"))
	_alienHateLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "I think what you need is not memory fixing. It is empathy."))
	_alienHateLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I beg you pardon?"))
	_alienHateLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Look, if you really want to be politically correct, maybe you should try something else."))
	_alienHateLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Listen to other species, learn more about their culture..."))
	_alienHateLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Neuroplacent-space-bugshit!"))
	_alienHateLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "I'm outta here. And don't expect credits!"))
	
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
		
	# 1. get tags
	var happyCount = 0
	var unchanged = false
	for s in souvenirs:
		if s.tags.find(Enums.MemTag.Sad) >= 0 and s.tags.find(Enums.MemTag.Alien) >= 0 and s.tags.find(Enums.MemTag.Trauma) >= 0:
			unchanged = true
			break
		if s.tags.find(Enums.MemTag.Happy) >= 0 and s.tags.find(Enums.MemTag.Alien) >= 0:
			happyCount += 1
			
	# 2. check tags
	if unchanged:
		_pay = 0
		LoadLines(_alienHateLines)
	else:
		if happyCount == 3:
			_pay = 1200
			UnlockScenario.emit(ScenarioConst.Aandrisk)
			LoadLines(_alienLoveLines)
		else:
			_pay = 800
			LoadLines(_alienFearLines)

	
	_state = Enums.ScenarioState.OperationResult
	_completed = true
	return isFried

func _isFried(souvenirs : Array[MemoryData]) -> bool:
	for s in souvenirs:
		if s.tags.find(Enums.MemTag.Alien) < 1:
			return true
	return false
