extends Node
class_name MemoryBank

var _memoryBank: Array[MemoryData] = []
	
func _ready():
	_memoryBank.append(load("res://Memories/Addictions/Drunk.tres"))
	_memoryBank.append(load("res://Memories/Crime/Robbed.tres"))
	#_memoryBank.append(load("res://Memories/Work/Reward.tres"))
	
func GetCurrentMemories() -> Array[MemoryData]:
	return _memoryBank.duplicate()

func AddMemory(memory : MemoryData) -> void:
	_memoryBank.append(memory)
	
func Consume(memory : MemoryData):
	var index = _memoryBank.find(memory)
	if (index >= 0):
		_memoryBank.erase(memory)		

func LoadStartingMemory():
	_memoryBank.clear()
	_memoryBank.append(load("res://Memories/Addictions/Drunk.tres"))
	_memoryBank.append(load("res://Memories/Crime/Robbed.tres"))	
