class_name OperationRoom extends CanvasLayer

@export var operation_data: OperationData
@export var memory_bank: Array[MemoryData]
#TODO: connect memory_bank to static class

func _ready():
	UpdateMemoryQueue()
	UpdateMemoryBank()

func UpdateMemoryQueue():
	pass

func UpdateMemoryBank():
	pass
