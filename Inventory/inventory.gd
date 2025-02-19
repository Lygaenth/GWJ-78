extends CanvasLayer
class_name Inventory

const memoryButtonPs : PackedScene = preload("res://OperationRoom/memory_button.tscn")

func _ready():
	var memories = PlayerSingleton.GetAvailableMemories()
	
	for memory in memories:
		var button : MemoryButton = memoryButtonPs.instantiate() 
		%GridContainer.add_child(button)
		button.DisplayInBank(memory)

func Display():
	show()
	
func OnClosePressed():
	hide()
	
