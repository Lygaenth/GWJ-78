extends Node
class_name OperationRoomFactory

const operationRoomPs : PackedScene = preload("res://OperationRoom/OperationRoom.tscn")

func CreateOperationRoom(memoryThread : MemoryThread) -> OperationRoom:
	var operationRoom = operationRoomPs.instantiate() as OperationRoom
	var data = OperationData.new()
	data.customer_query = memoryThread.Query
	data.memory_data = memoryThread.ToArray()
	operationRoom.operation_data = data
	return operationRoom
