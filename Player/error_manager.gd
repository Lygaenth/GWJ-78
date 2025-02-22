extends Node
class_name ErrorManager

var _error1Lines : Array[DialogLine] = []
var _error2Lines : Array[DialogLine] = []
var _error3Lines : Array[DialogLine] = []

var _copLines : Array[DialogLine]
var _copLineIndex : int = 0
var _specificLine : DialogLine
var _friedCharacters : Array[CharacterBase]

var _releasedAnAi : bool = false

func _ready():
	InitializeLines()
	
func InitializeLines():
	_copLineIndex = 0
	_friedCharacters.clear()
	_error1Lines.clear()
	_error2Lines.clear()
	_error3Lines.clear()
	_error1Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Techno-dammit, I messed up!)"))
	_error1Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Quick, let's erase everything that can lead back to me...)"))
	_error1Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(There. Never happened.)"))
	_error1Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I should be more cautious from now on.)"))
	
	_error2Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(No no no no no...)"))
	_error2Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I can't do that"))
	_error2Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Those patient's memory might degenerate from the inconsistency...)"))
	_error2Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(The Watchers might know...)"))
	_error2Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I can't be caught, I must severe all links as best as I can.)"))
	_error2Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I'll erase traces from my memories too...)"))

	_error3Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Poor thing... What did I miss ?)"))
	_error3Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Hope a partial reset will work.)"))
	_error3Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I'll remove traces of my intervention...)"))
	_error3Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Then send an anonymous alert at his place.)"))
	_error3Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I'll do better next time.)"))
	_error3Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(I'll erase my own memory to stay confident...)"))
	_error3Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Did I ever do that before by the way ?)"))
	_error3Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "..."))
	_error3Lines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "(Oh, I didn't have any patient today. Day passed so fast)"))

	_copLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "Dr. Lethe !"))
	_copLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "You're under arrest for having destroy eleven minds."))
	_copLines.append(DialogLineFactory.CreateLine(Enums.Talker.Doctor, "Eleven ?! I don't remember any of that !"))
	_copLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "We do have proof though."))
	_specificLine = DialogLineFactory.CreateLine(Enums.Talker.Patient, "We investigated the bodies of ")
	_copLines.append(_specificLine)
	_copLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "All three remains led us to you. You will pay for you crime."))
	_copLines.append(DialogLineFactory.CreateLine(Enums.Talker.Patient, "In the Eternal Slop."))

func GetErrorDialog() -> Array[DialogLine]:
	match(_friedCharacters.size()):
		1: 
			return _error1Lines
		2: 
			return _error2Lines
		3: 
			return _error3Lines
	return []

func HasTooManyError() -> bool:
	return _friedCharacters.size() == 3

func AddFriedCharacter(character : CharacterBase) -> void:
	_friedCharacters.append(character)
	if (_friedCharacters.size() == 3):
		ActivateBadEnding()

func ActivateBadEnding():
	_specificLine.Text += _friedCharacters[0].GetFullName()+", "+_friedCharacters[1].GetFullName()+", "+_friedCharacters[2].GetFullName()
		
func GetCopLines() -> DialogLine:
	if (_copLineIndex == _copLines.size()):
		return null
		
	var line = _copLines[_copLineIndex]
	_copLineIndex+=1
	return line

func ReleaseAi():
	_releasedAnAi = true
	
func HasReleasedAnAi():
	return _releasedAnAi
