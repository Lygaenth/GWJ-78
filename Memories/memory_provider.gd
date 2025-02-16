class_name MemoryProvider extends Node

var _memories : Array[MemoryData] = []

func _ready():
	_memories.append(load("res://Memories/Happy/BirthdayParty.tres") as MemoryData)
	_memories.append(load("res://Memories/Happy/Present.tres") as MemoryData)
	_memories.append(load("res://Memories/Happy/BirthdayParty.tres") as MemoryData)
	_memories.append(load("res://Memories/Happy/Present.tres") as MemoryData)
	_memories.append(load("res://Memories/Happy/BirthdayParty.tres") as MemoryData)
	_memories.append(load("res://Memories/Happy/Present.tres") as MemoryData)
	_memories.append(load("res://Memories/Happy/BirthdayParty.tres") as MemoryData)
	_memories.append(load("res://Memories/Happy/Present.tres") as MemoryData)

	return _memories
	
func GetAllMemories() -> Array[MemoryData]:
	return _memories
