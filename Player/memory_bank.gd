extends Node
class_name MemoryBank

var _memoryBank: Array[MemoryData] = []
	
func GetCurrentMemories() -> Array[MemoryData]:
	return _memoryBank.duplicate()

func AddMemory(memory : MemoryData) -> void:
	return _memoryBank.append(memory)
	
func Consume(memory : MemoryData):
	var index = _memoryBank.find(memory)
	if (index >= 0):
		_memoryBank.erase(memory)
