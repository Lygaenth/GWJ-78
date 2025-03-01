class_name MemoryButton extends TextureButton

@onready var title_label: Label = $"%MemoryLabel"
@onready var cost_label: Label = $"%CostLabel"
@onready var context_menu: PanelContainer = $ContextualMenu
@onready var context_title: Label = $ContextualMenu/MarginContainer/VBoxContainer/ContextTitleLabel
@onready var context_description: RichTextLabel = $ContextualMenu/MarginContainer/VBoxContainer/RichTextLabel
@onready var on_ready_memory: MemoryData

@onready var keep_button: Button = $ContextualMenu/MarginContainer/VBoxContainer/KeepButton
@onready var insert_button: Button = $ContextualMenu/MarginContainer/VBoxContainer/InsertButton
@onready var sell_button: Button = $ContextualMenu/MarginContainer/VBoxContainer/SellButton
@onready var erase_button: Button = $ContextualMenu/MarginContainer/VBoxContainer/EraseButton


signal Updated()
signal DisplayDescription(desc : String)

var shopMemoryButtonPs = load("res://Store/ShopMemoryButton.tscn")

signal send_memory_to_bank(memory: MemoryData)
signal update_memory_bank

#region Methods to display memory buttons
#...in the shop
func DisplayInShop(memory: MemoryData):
	Update(memory)
	keep_button.hide()
	insert_button.hide()
	cost_label.show()
	if (PlayerSingleton._memoryBank.CanEraseOrSell()):
		sell_button.show()
		erase_button.show()
	else:
		sell_button.hide()
		erase_button.hide()

#... in the bank
func DisplayInBank(memory: MemoryData):
	Update(memory)
	keep_button.hide()
	insert_button.hide()
	cost_label.hide()
	sell_button.show()
	if (PlayerSingleton._memoryBank.CanEraseOrSell()):
		sell_button.show()
		erase_button.show()
	else:
		sell_button.hide()
		erase_button.hide()

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
	if (memory.memory_cost > 0):
		sell_button.text = str(tr("MEMORY_BUTTON_SELL") % (memory.memory_cost / 2))
		sell_button.disabled = false
	else:
		sell_button.text = "MEMORY_BUTTON_CANNOT_SELL"
		sell_button.disabled = true
		
	# Description
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
	%BlipSound.play()
	if (PlayerSingleton._memoryBank.CanEraseOrSell() && sell_button.visible):
		sell_button.show()
		erase_button.show()
	else:
		sell_button.hide()
		erase_button.hide()
	context_menu.global_position = global_position - Vector2(180, 180)
	context_menu.show()

func _on_contextual_menu_mouse_exited():
	context_menu.hide()

func _on_button_down():
	pass

func _on_button_up():
	pass

#region Context menu buttons
func _on_keep_button_pressed():
	%ActionSound.play()	
	# send a signal to operation room - it will add memory to bank
	send_memory_to_bank.emit(on_ready_memory)
	# empty current memory
	var empty_memory = NewEmptyMemory()
	DisplayInEraser(empty_memory)
	Updated.emit()

func _on_insert_button_pressed():
	%ActionSound.play()	
	context_menu.hide()

	var memory_choice_menu : MemoryChoiceMenu = MemoryButtonFactory.CreateMemoryChoiceContext()
	add_child(memory_choice_menu)
	memory_choice_menu.SelectedItem.connect(_on_memory_choice_menu_selected_item)
	memory_choice_menu.Load()

func _on_sell_button_pressed():
	%ActionSound.play()
	hide()
	PlayerSingleton.UpdateMoney(on_ready_memory.memory_cost / 2)
	PlayerSingleton._memoryBank.Consume(on_ready_memory)
	print("memory sent to shop")
	await get_tree().create_timer(0.2)
	queue_free()

func _on_erase_button_pressed():
	%ActionSound.play()
	hide()
	PlayerSingleton._memoryBank.Consume(on_ready_memory)
	await get_tree().create_timer(0.2)
	queue_free()

#endregion


func _on_memory_choice_menu_selected_item(item):
	%ActionSound.play()
	DisplayInEraser(item)
	await get_tree().create_timer(0.2)
	PlayerSingleton._memoryBank.Consume(item)
	update_memory_bank.emit()
	Updated.emit()
