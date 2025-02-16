class_name OperationRoom extends CanvasLayer

@export var operation_data: OperationData
@export var memory_bank: Array[MemoryData]
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
	for index in operation_data.memory_data_array.size():
		var memory_instance = memory_prefab.instantiate()
		memory_queue_container.add_child(memory_instance)
		memory_instance.DisplayInEraser(operation_data.memory_data_array[index])

func UpdateMemoryBank():
	for memory in memory_bank:
		var memory_instance = memory_prefab.instantiate()
		memory_bank_container.add_child(memory_instance)
		memory_instance.DisplayInShop(memory)

func AddMemoryToQueue(memory: MemoryData):
	pass

func RemoveMemoryFromQueue(memory: MemoryData):
	pass

func AddMemoryToBank(memory: MemoryData):
	pass

func RemoveMemoryFromBank(memory: MemoryData):
	pass


func _on_button_pressed():
	confirm_operation.emit(operation_data)
