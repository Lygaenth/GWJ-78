class_name MemoryButton extends TextureButton

@onready var title_label: Label = $"%MemoryLabel"
@onready var cost_label: Label = $"%CostLabel"
@onready var memory_choice_menu = $MemoryChoiceMenu
@onready var context_menu: PanelContainer = $ContextualMenu
@onready var context_title: Label = $ContextualMenu/MarginContainer/VBoxContainer/ContextTitleLabel
@onready var context_description: RichTextLabel = $ContextualMenu/MarginContainer/VBoxContainer/RichTextLabel
@onready var on_ready_memory: MemoryData

@onready var keep_button: Button = $ContextualMenu/MarginContainer/VBoxContainer/KeepButton
@onready var insert_button: Button = $ContextualMenu/MarginContainer/VBoxContainer/InsertButton
@onready var sell_button: Button = $ContextualMenu/MarginContainer/VBoxContainer/SellButton
@onready var erase_button: Button = $ContextualMenu/MarginContainer/VBoxContainer/EraseButton
@onready var accept_button: Button = %AcceptMemoryTransferButton
@onready var cancel_button: Button = %CancelMemoryTransferButton
@onready var grid_container = %GridContainerMemoryChoiceButton

signal Updated()

var shopMemoryButtonPs = load("res://Store/ShopMemoryButton.tscn")
var _selectedItem: MemoryData

signal send_memory_to_bank(memory: MemoryData)
signal send_memory_to_shop(memory: MemoryData)
signal update_memory_bank

#region Methods to display memory buttons
#...in the shop
func DisplayInShop(memory: MemoryData):
	Update(memory)
	keep_button.hide()
	insert_button.hide()
	cost_label.show()
	sell_button.show()
	erase_button.show()

#... in the bank
func DisplayInBank(memory: MemoryData):
	Update(memory)
	keep_button.hide()
	insert_button.hide()
	cost_label.show()
	sell_button.show()
	erase_button.show()

#...in the memory eraser
func DisplayInEraser(memory: MemoryData):
	Update(memory)
	cost_label.hide()
	# case memory cannot be clicked (start/end of scenario)
	if !memory.can_be_clicked:
		keep_button.hide()
		insert_button.hide()
		sell_button.hide()
		erase_button.hide()
	# case memory is not empty (can be kept)
	if memory.can_be_clicked and !memory.is_empty:
		keep_button.show()
		insert_button.hide()
		sell_button.hide()
		erase_button.hide()
	# case memory is empty (player can insert new memory)
	if memory.can_be_clicked and memory.is_empty:
		keep_button.hide()
		sell_button.hide()
		erase_button.hide()
		insert_button.show()

func Update(memory: MemoryData):
	on_ready_memory = memory
	# Title
	title_label.text = memory.memory_title
	context_title.text = memory.memory_title
	# Cost
	cost_label.text = str("$", memory.memory_cost)
	sell_button.text = str("Sell for $", memory.memory_cost)
	# Description
	tooltip_text = memory.memory_description
	%Icon.texture = memory.memory_thumbnail
	context_description.text = memory.memory_description
	# Thumbnail
	#texture_normal = memory.memory_thumbnail
	#texture_hover = memory.memory_thumbnail
	#texture_pressed = memory.memory_thumbnail
	#texture_focused = memory.memory_thumbnail

func NewEmptyMemory():
	var memory = load("res://Memories/Logic/Empty.tres")
	return memory
#endregion

func _on_pressed():
	context_menu.show()

func _on_contextual_menu_mouse_exited():
	context_menu.hide()

func _on_button_down():
	scale = Vector2(.8, .8)

func _on_button_up():
	scale = Vector2(1, 1)

func _on_mouse_entered():
	scale = Vector2(1.2, 1.2)

func _on_mouse_exited():
	scale = Vector2(1, 1)


#region Context menu buttons
func _on_keep_button_pressed():
	# send a signal to operation room - it will add memory to bank
	send_memory_to_bank.emit(on_ready_memory)
	# empty current memory
	var empty_memory = NewEmptyMemory()
	DisplayInEraser(empty_memory)
	Updated.emit()

func _on_insert_button_pressed():
	context_menu.hide()
	memory_choice_menu.show()
	var memories = PlayerSingleton.GetAvailableMemories()
	for m in memories:
		var button : ShopMemoryButton = shopMemoryButtonPs.instantiate() 
		grid_container.add_child(button)
		button.Update(m)
		button.Selected.connect(OnItemStateChanged)


func _on_sell_button_pressed():
	send_memory_to_shop.emit(on_ready_memory)
	print("memory sent to shop")
	await get_tree().create_timer(0.2)
	queue_free()

func _on_erase_button_pressed():
	await get_tree().create_timer(0.2)
	queue_free()

func OnItemStateChanged(isSelected : bool, memory : MemoryData):
	if (isSelected):
		for shopButton : ShopMemoryButton in grid_container.get_children():
			if shopButton.IsSelected() && shopButton.on_ready_memory != memory:
				shopButton.UpdateSelection()
		_selectedItem = memory
		accept_button.disabled = false
	else:
		_selectedItem = null
		accept_button.disabled = true

func _on_accept_button_pressed():
	DisplayInEraser(_selectedItem)
	await get_tree().create_timer(0.2)
	for memoryButton : ShopMemoryButton in grid_container.get_children():
		if (memoryButton.IsSelected()):
			PlayerSingleton._memoryBank.Consume(_selectedItem)
		memoryButton.queue_free()
	update_memory_bank.emit()
	ResetMemoryChoiceMenu()
	Updated.emit()

func _on_cancel_button_pressed():
	ResetMemoryChoiceMenu()

func ResetMemoryChoiceMenu():
	_selectedItem = null
	accept_button.disabled = true
	memory_choice_menu.hide()
#endregion
