extends CanvasLayer
class_name Inventory

const memoryButtonPs : PackedScene = preload("res://Inventory/InventoryMemoryButton.tscn")

signal SwitchToStore();
signal Closed()

func _ready():
	LoadMemories()

func LoadMemories():
	for child in %GridContainer.get_children():
		child.queue_free()
		
	var memories = PlayerSingleton.GetAvailableMemories()	
	for memory in memories:
		var button : InventoryMemoryButton = memoryButtonPs.instantiate() 
		%GridContainer.add_child(button)
		button.DisplayInBank(memory)
		button.DisplayDescription.connect(OnButtonDisplayDesc)	

func Display():
	LoadMemories()
	show()
	%StoreButton.disabled = PlayerSingleton.IsShopLock()
	
func OnClosePressed():
	%ActionSound.play()
	Closed.emit()
	hide()
	
func OnButtonDisplayDesc(desc : String):
	%ActionSound.play()
	%DescriptionLabel.text = desc

func _on_store_button_pressed():
	%ActionSound.play()
	SwitchToStore.emit()
