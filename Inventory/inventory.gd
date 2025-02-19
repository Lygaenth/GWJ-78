extends CanvasLayer
class_name Inventory

const memoryButtonPs : PackedScene = preload("res://Inventory/InventoryMemoryButton.tscn")

signal SwitchToStore();

func _ready():
	var memories = PlayerSingleton.GetAvailableMemories()
	
	for memory in memories:
		var button : InventoryMemoryButton = memoryButtonPs.instantiate() 
		%GridContainer.add_child(button)
		button.DisplayInBank(memory)
		button.DisplayDescription.connect(OnButtonDisplayDesc)

func Display():
	show()
	
func OnClosePressed():
	hide()
	
func OnButtonDisplayDesc(desc : String):
	%DescriptionLabel.text = desc


func _on_store_button_pressed():
	SwitchToStore.emit()
