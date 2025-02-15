class_name MemoryThread extends Resource

@export var Query : String
@export var StartMemory : MemoryData
@export var IntermediateMemories : Array[MemoryData]
@export var EndMemory : MemoryData

func ToArray() -> Array[MemoryData]:
	var array : Array[MemoryData] = [StartMemory]
	array.append_array(IntermediateMemories)
	array.append(EndMemory)
	return array
