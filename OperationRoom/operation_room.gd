class_name OperationRoom extends CanvasLayer

@export var operation_data: OperationData

@onready var query_label = %CustomerQueryLabel
@onready var memory_queue_container = %HBoxContainer_memory_queue
@onready var memory_prefab = load("res://OperationRoom/memory_button.tscn")
@onready var empty_memory_thumbnail = load("res://icon.svg")
@onready var confirmButton = %ConfirmButton

signal confirm_operation(data: OperationData)

func _ready():
	UpdateLabel()
	UpdateMemoryQueue()
	CheckConfirmationEnabled()
	if (!PlayerSingleton._hasSeenTuto):
		%OperationTutoPanel.show()

func UpdateLabel():
	query_label.text = operation_data.customer_query

func UpdateMemoryQueue():
	for child in memory_queue_container.get_children():
		child.free()
	for memory : MemoryData in operation_data.memory_data_array:
		var memory_instance : MemoryButton = memory_prefab.instantiate()
		memory_queue_container.add_child(memory_instance)
		memory_instance.send_memory_to_bank.connect(AddMemoryToBank)
		memory_instance.DisplayInEraser(memory)
		memory_instance.Updated.connect(OnQueueUpdated)

func AddMemoryToBank(memory: MemoryData):
	PlayerSingleton._memoryBank.AddMemory(memory)
	print("memory bank size = ",PlayerSingleton.GetAvailableMemories().size())

func _on_button_pressed():
	var updatedMemories : Array[MemoryData]
	for btn : MemoryButton in memory_queue_container.get_children():
		updatedMemories.append(btn.on_ready_memory)
	confirm_operation.emit(updatedMemories)

func CheckConfirmationEnabled():
	var hasEmpty : bool = false
	var hasBroken : bool = false
	for btn : MemoryButton in memory_queue_container.get_children():
		if btn.on_ready_memory.tags.find(Enums.MemTag.Empty) >= 0:
			hasEmpty = true
		if btn.on_ready_memory.tags.find(Enums.MemTag.Broken) >= 0:
			hasBroken = true
	confirmButton.disabled = hasEmpty || hasBroken

func OnQueueUpdated():
	var btns : Array[MemoryButton] = []
	
	for btn : MemoryButton in memory_queue_container.get_children():
		btns.append(btn)
			
	var last = btns[btns.size() - 1]
	if (last.on_ready_memory.tags.find(Enums.MemTag.Unknown) < 0):
		last.Update(load("res://Memories/Logic/Unknown.tres"))

	CheckConfirmationEnabled()

func _on_close_tuto_btn_pressed():
	%OperationTutoPanel.hide()
	PlayerSingleton.ValidateTuto()
