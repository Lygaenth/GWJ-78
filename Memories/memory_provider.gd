class_name MemoryProvider extends Node

var _memories : Array[MemoryData] = []

func _ready():
	_memories.append(load("res://Memories/Happy/BirthDayParty.tres") as MemoryData)
	_memories.append(load("res://Memories/Happy/Present.tres") as MemoryData)
	_memories.append(load("res://Memories/Addictions/Drunk.tres") as MemoryData)
	_memories.append(load("res://Memories/Crime/Robbed.tres") as MemoryData)
	_memories.append(load("res://Memories/Family/FamilyFeud.tres") as MemoryData)
	_memories.append(load("res://Memories/Family/Gathering.tres") as MemoryData)
	_memories.append(load("res://Memories/Love/BreakUp.tres") as MemoryData)
	_memories.append(load("res://Memories/Love/TenderNight.tres") as MemoryData)
	_memories.append(load("res://Memories/Work/Disappointment.tres") as MemoryData)
	_memories.append(load("res://Memories/Work/CareerChange.tres") as MemoryData)
	_memories.append(load("res://Memories/Work/Promotion.tres") as MemoryData)
	_memories.append(load("res://Memories/Alien/AlienEmpathy.tres") as MemoryData)
	_memories.append(load("res://Memories/Alien/AlienFriendship.tres") as MemoryData)
	_memories.append(load("res://Memories/Alien/AlienHelp.tres") as MemoryData)
	return _memories
	
func GetAllMemories() -> Array[MemoryData]:
	return _memories
