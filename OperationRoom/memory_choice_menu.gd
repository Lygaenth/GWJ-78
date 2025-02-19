extends PanelContainer

var shopMemoryButtonPs = load("res://Store/ShopMemoryButton.tscn")

@onready var accept_button: Button = %AcceptMemoryTransferButton
@onready var cancel_button: Button = %CancelMemoryTransferButton
@onready var grid_container = %GridContainerMemoryChoiceButton

signal SelectedItem( item : MemoryData)
var _selectedItem: MemoryData

func OnItemStateChanged(isSelected : bool, memory : MemoryData):
	if (isSelected):
		for shopButton : ShopMemoryButton in grid_container.get_children():
			if shopButton.IsSelected() && shopButton.on_ready_memory != memory:
				shopButton.UpdateSelection()
		_selectedItem = memory
		EnableAcceptButton()
	else:
		_selectedItem = null
		DisableAcceptButton()

func Load():
	var memories = PlayerSingleton.GetAvailableMemories()
	for m in memories:
		var button : ShopMemoryButton = shopMemoryButtonPs.instantiate() 
		grid_container.add_child(button)
		button.Update(m)
		button.Selected.connect(OnItemStateChanged)


func _on_accept_button_pressed():
	%ActionSound.play()
	SelectedItem.emit(_selectedItem)
	ResetMemoryChoiceMenu()



func _on_cancel_button_pressed():
	%ActionSound.play()
	ResetMemoryChoiceMenu()

func ResetMemoryChoiceMenu():
	_selectedItem = null
	for button in grid_container.get_children():
		button.queue_free()

	DisableAcceptButton()
	hide()

func DisableAcceptButton():
	accept_button.disabled = true
	
func EnableAcceptButton():
	accept_button.disabled = false
