class_name OperationRoom extends CanvasLayer

@export var operation_data: OperationData
#TODO: connect memory_bank to static class

@onready var query_label = %CustomerQueryLabel
@onready var memory_queue_container = %HBoxContainer_memory_queue
@onready var memory_bank_container = %HBoxContainer_memory_bank
@onready var memory_prefab = load("res://OperationRoom/memory_button.tscn")
@onready var empty_memory_thumbnail = load("res://icon.svg")

signal confirm_operation(data: OperationData)

func _ready():
	UpdateLabel()
	UpdateMemoryQueue()
	UpdateMemoryBank()

func UpdateLabel():
	query_label.text = operation_data.customer_query

func UpdateMemoryQueue():
	for child in memory_queue_container.get_children():
		child.free()
	for memory in operation_data.memory_data_array:
		var memory_instance = memory_prefab.instantiate()
		memory_queue_container.add_child(memory_instance)
		memory_instance.send_memory_to_bank.connect(AddMemoryToBank)
		memory_instance.update_memory_bank.connect(UpdateMemoryBank)
		memory_instance.DisplayInEraser(memory)

func UpdateMemoryBank():
	for child in memory_bank_container.get_children():
		child.free()
	for memory in PlayerSingleton.GetAvailableMemories():
		var memory_instance = memory_prefab.instantiate()
		memory_bank_container.add_child(memory_instance)
		memory_instance.DisplayInShop(memory)

func AddMemoryToBank(memory: MemoryData):
	PlayerSingleton._memoryBank.AddMemory(memory)
	print("memory bank size = ",PlayerSingleton.GetAvailableMemories().size())
	UpdateMemoryBank()

func _on_button_pressed():
	confirm_operation.emit(operation_data)
