class_name OperationRoom extends CanvasLayer

@export var operation_data: OperationData
@export var memory_bank: Array[MemoryData]
#TODO: connect memory_bank to static class

@onready var memory_queue_container = %HBoxContainer_memory_queue
@onready var memory_bank_container = %HBoxContainer_memory_bank
@onready var memory_prefab = load("res://OperationRoom/memory_button.tscn")

func _ready():
	UpdateMemoryQueue()
	UpdateMemoryBank()

func UpdateMemoryQueue():
	for memory in operation_data.memory_data_array:
		var memory_instance = memory_prefab.instantiate()
		memory_queue_container.add_child(memory_instance)
		memory_instance.DisplayInEraser(memory)

func UpdateMemoryBank():
	for memory in memory_bank:
		var memory_instance = memory_prefab.instantiate()
		memory_bank_container.add_child(memory_instance)
		memory_instance.DisplayInShop(memory)

func AddMemoryToQueue(memory: MemoryData, position: int):
	pass
