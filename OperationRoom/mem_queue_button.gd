class_name MemoryQueueButton extends TextureButton

@onready var title_label: Label = $VBoxContainer/MemQueueLabel
@onready var title_text: String
@onready var description_text: String
@onready var thumbnail_texture: Texture2D

func _ready():
	Update()

func Update():
	title_label.text = title_text
	tooltip_text = description_text
	texture_normal = thumbnail_texture
	texture_hover = thumbnail_texture
	texture_pressed = thumbnail_texture
	texture_focused = thumbnail_texture
