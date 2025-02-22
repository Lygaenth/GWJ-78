extends Label
class_name CharacterDialog

var _line : String = ""
var _index : int = 0
var _wait : float = 0
var _skipFrames : int = 0
var _emited : bool = false
signal CompletedLine()

func _process(delta):
	_skipFrames+= 1
	if (_skipFrames < 2):
		return
		
	_skipFrames = 0
	if (text.ends_with("... ")):
		_wait+= delta
		if (_wait < 0.2):
			return
	_wait = 0
	if (_index < _line.length()):
		text = text + _line[_index]
		_index += 1
	if (_line.length() > 0 && _index == _line.length() && !_emited):
		CompletedLine.emit()
		_emited = true


func DisplayLine(line : String):
	_emited = false
	_index = 0
	_line = line
	text = ""

func ForceComplete():
	_emited = true
	text = _line
	_index = _line.length()
