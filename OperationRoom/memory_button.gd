class_name MemoryButton extends TextureButton

@onready var title_label: Label = $VBoxContainer/MemoryLabel
@onready var cost_label: Label = $VBoxContainer/CostLabel
@onready var on_ready_memory: MemoryData
@onready var internal_texture : TextureRect = $VBoxContainer/TextureRect

#region Methods to display memory buttons
#...in the shop
func DisplayInShop(memory: MemoryData):
	on_ready_memory = memory
	Update(memory)
	cost_label.show()

#...in the memory eraser
func DisplayInEraser(memory: MemoryData):
	on_ready_memory = memory
	Update(memory)
	cost_label.hide()
#endregion

func Update(memory: MemoryData):
	title_label.text = memory.memory_title
	cost_label.text = str(memory.memory_cost, " credits")
	tooltip_text = memory.memory_description
	internal_texture.texture = memory.memory_thumbnail
	#internal_texture.texture_hover = memory.memory_thumbnail
	#internal_texture.texture_pressed = memory.memory_thumbnail
	#internal_texture.texture_focused = memory.memory_thumbnail

func _on_pressed():
	print("a button has been pressed!")

func _on_button_down():
	scale = Vector2(.8, .8)

func _on_button_up():
	scale = Vector2(1, 1)

func _on_mouse_entered():
	scale = Vector2(1.2, 1.2)

func _on_mouse_exited():
	scale = Vector2(1, 1)
