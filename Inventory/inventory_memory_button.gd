extends MemoryButton
class_name InventoryMemoryButton



func _on_button_down():
	pass

func _on_button_up():
	pass

func _on_mouse_entered():
	DisplayDescription.emit(on_ready_memory.memory_description)

func _on_mouse_exited():
	DisplayDescription.emit("")
