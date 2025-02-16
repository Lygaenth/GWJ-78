class_name OperationRoom extends CanvasLayer

@export var operation_data: OperationData
#TODO: connect memory_bank to static class

@onready var query_label = %CustomerQueryLabel
@onready var memory_queue_container = %HBoxContainer_memory_queue
@onready var memory_bank_container = %HBoxContainer_memory_bank
@onready var memory_prefab = load("res://OperationRoom/memory_button.tscn")
@onready var empty_memory_thumbnail = load("res://icon.svg")
@onready var confirmButton = %ConfirmButton

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
	for memory : MemoryData in operation_data.memory_data_array:
		var memory_instance : MemoryButton = memory_prefab.instantiate()
		memory_queue_container.add_child(memory_instance)
		memory_instance.send_memory_to_bank.connect(AddMemoryToBank)
		memory_instance.update_memory_bank.connect(UpdateMemoryBank)
		memory_instance.DisplayInEraser(memory)
		memory_instance.Updated.connect(OnQueueUpdated)

func UpdateMemoryBank():
	for child in memory_bank_container.get_children():
		child.free()
	for memory in PlayerSingleton.GetAvailableMemories():
		var memory_instance = memory_prefab.instantiate()
		memory_bank_container.add_child(memory_instance)
		memory_instance.DisplayInEraser(memory)

func AddMemoryToBank(memory: MemoryData):
	PlayerSingleton._memoryBank.AddMemory(memory)
	print("memory bank size = ",PlayerSingleton.GetAvailableMemories().size())
	UpdateMemoryBank()

func _on_button_pressed():
	var updatedMemories : Array[MemoryData]
	for btn : MemoryButton in memory_queue_container.get_children():
		updatedMemories.append(btn.on_ready_memory)
	confirm_operation.emit(updatedMemories)

func OnQueueUpdated():
	var hasEmpty : bool = false
	var btns : Array[MemoryButton] = []

	for btn : MemoryButton in memory_queue_container.get_children():
		btns.append(btn)
		if btn.on_ready_memory.tags.find(Enums.MemTag.Empty) >= 0:
			hasEmpty = true

	confirmButton.disabled = hasEmpty
	var last = btns[btns.size() - 1]
	if (last.on_ready_memory.tags.find(Enums.MemTag.Unknown) < 0):
		last.Update(load("res://Memories/Logic/Unknown.tres"))
