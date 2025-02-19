extends MemoryButton
class_name  ShopMemoryButton

var _isSelected : bool

func _ready():
	on_ready_memory = MemoryData.new()
	on_ready_memory.memory_cost = 500

signal Selected(isSelected : bool, price : MemoryData)

func IsSelected() -> bool:
	return _isSelected

func _on_button_down():
	pass

func _on_button_up():
	pass

func _on_mouse_entered():
	DisplayDescription.emit(on_ready_memory.memory_description)

func _on_mouse_exited():
	DisplayDescription.emit("")

func _on_pressed():
	UpdateSelection()

func UpdateSelection():
	_isSelected = !_isSelected
	if (_isSelected):
		modulate = Color("bf195f")
	else:
		modulate = Color("ffffff")
	
	Selected.emit(_isSelected, on_ready_memory)
