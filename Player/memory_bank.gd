extends Node
class_name MemoryBank

var _memoryBank: Array[MemoryData] = []
	
func _ready():
	_memoryBank.append(load("res://Memories/Happy/BirthDayParty.tres"))
	_memoryBank.append(load("res://Memories/Family/Gathering.tres"))
	_memoryBank.append(load("res://Memories/Love/TenderNight.tres"))
	_memoryBank.append(load("res://Memories/Family/FamiliyFeud.tres"))
	
func GetCurrentMemories() -> Array[MemoryData]:
	return _memoryBank.duplicate()

func AddMemory(memory : MemoryData) -> void:
	_memoryBank.append(memory)
	
func Consume(memory : MemoryData):
	var index = _memoryBank.find(memory)
	if (index >= 0):
		_memoryBank.erase(memory)		
