class_name MemoryData extends Resource

@export var memory_title: String = ""
@export var memory_description: String = ""
@export var memory_cost: int = 0
@export var memory_thumbnail: Texture2D = load("res://Memories/DefaultIcon.png")
@export var can_be_clicked: bool = true
@export var is_empty: bool = false
@export var tags : Array[Enums.MemTag] = []
@export var memType : Enums.MemType = Enums.MemType.Any
