class_name MemoryButton extends TextureButton

@onready var title_label: Label = $"%MemoryLabel"
@onready var cost_label: Label = $"%CostLabel"
@onready var context_menu: Control = $ContextualMenu
@onready var context_title: Label = $ContextualMenu/MarginContainer/VBoxContainer/ContextTitleLabel
@onready var context_description: RichTextLabel = $ContextualMenu/MarginContainer/VBoxContainer/RichTextLabel
@onready var on_ready_memory: MemoryData
@onready var keep_button: Button = $ContextualMenu/MarginContainer/VBoxContainer/KeepButton
@onready var insert_button: Button = $ContextualMenu/MarginContainer/VBoxContainer/InsertButton
@onready var sell_button: Button = $ContextualMenu/MarginContainer/VBoxContainer/SellButton

#region Methods to display memory buttons
#...in the shop
func DisplayInShop(memory: MemoryData):
	Update(memory)
	cost_label.show()
	keep_button.hide()
	insert_button.show()

#...in the memory eraser
func DisplayInEraser(memory: MemoryData):
	Update(memory)
	cost_label.hide()
	self.disabled = !memory.can_be_clicked
	keep_button.show()
	insert_button.hide()
#endregion

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

func _on_pressed():
	context_menu.show()
	print("a button has been pressed!")

func _on_button_down():
	scale = Vector2(.8, .8)

func _on_button_up():
	scale = Vector2(1, 1)

func _on_mouse_entered():
	scale = Vector2(1.2, 1.2)

func _on_mouse_exited():
	scale = Vector2(1, 1)

func _on_contextual_menu_mouse_exited():
	context_menu.hide()
