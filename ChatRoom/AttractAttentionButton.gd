extends Button
class_name AttractAttentionButton

var _attractAttention : bool = false
var _counter : float = 0
var _isOn = false

func _process(delta : float):
	if (!_attractAttention):
		return

	_counter += delta
	if (_counter > 2):
		_counter = _counter - 2

	if (!_isOn && _counter < 1):
		modulate = Color(1, 0, 0)
		_isOn = true

	if (_isOn && _counter > 1):
		modulate = Color(0,1,1)
		_isOn = false

func Attract():
	_counter = 0
	_attractAttention = true

func Stop():
	_counter = 0
	modulate = Color(0,1,1)
	_attractAttention = false
