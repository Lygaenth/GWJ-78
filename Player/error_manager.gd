extends Node
class_name ErrorManager

var _error1Lines : Array[DialogLine] = []
var _error2Lines : Array[DialogLine] = []
var _error3Lines : Array[DialogLine] = []

var _copLines : Array[DialogLine]
var _copLineIndex : int = 0
var _friedCharacters : Array[CharacterBase]

var _releasedAnAi : bool = false

func _ready():
	InitializeLines()
	
func InitializeLines():
	var dialogsByKeys = DialogLineProvider.GetDialogs("res://Translations/ErrorDialogs.csv" , ["Error1_DIALOG", "Error2_DIALOG", "Error3_DIALOG",  "COPSCOMING_DIALOG"])

	for line : String in dialogsByKeys["Error1_DIALOG"]:
		var talker = GetTalker(line)
		_error1Lines.append(DialogLineFactory.CreateLine(talker, line))

	for line : String in dialogsByKeys["Error2_DIALOG"]:
		var talker = GetTalker(line)
		_error2Lines.append(DialogLineFactory.CreateLine(talker, line))
	
	for line : String in dialogsByKeys["Error3_DIALOG"]:
		var talker = GetTalker(line)
		_error3Lines.append(DialogLineFactory.CreateLine(talker, line))
	
	for line : String in dialogsByKeys["COPSCOMING_DIALOG"]:
		var talker = GetTalker(line)
		_copLines.append(DialogLineFactory.CreateLine(talker, line))

func GetTalker(line : String) -> Enums.Talker:
	var talker : Enums.Talker = Enums.Talker.Patient
	if (line.find("DOCTOR") >= 0):
		talker = Enums.Talker.Doctor
	return talker

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
	for line : DialogLine in _copLines:
		if (line.Text.contains("COPSCOMING_DIALOG_START_LINE_4_PATIENT")):
			line.Text = tr(line.Text)+ _friedCharacters[0].GetFullName()+", "+_friedCharacters[1].GetFullName()+", "+_friedCharacters[2].GetFullName()
		
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
