extends MemoryButton
class_name  ShopMemoryButton

var _isSelected : bool

func _ready():
	on_ready_memory = MemoryData.new()
	on_ready_memory.memory_cost = 500

signal Selected(isSelected : bool, price : MemoryData)

func _on_button_down():
	pass

func _on_button_up():
	pass

func _on_mouse_entered():
	pass

func _on_mouse_exited():
	pass

func _on_pressed():
	_isSelected = !_isSelected
	Selected.emit(_isSelected, on_ready_memory)
