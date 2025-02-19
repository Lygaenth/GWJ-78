extends MoneyLabel
class_name  PayLabel

var counter : float = 0
var _display : bool = false

func Display():
	_display = true
	counter = 0
	show()

func Hide():
	_display = false
	hide()

func _process(delta):
	counter += delta
	if (counter < 0.5):
		hide()
	
	if (_display && counter > 0.5):
		show()
		
	if (counter > 1.0):
		counter = 0
