class_name MemoryButtonFactory extends Node 

const _MemoryChoiceMenuPs : PackedScene = preload("res://OperationRoom/memoryChoiceMenu.tscn")

static func CreateMemoryChoiceContext() -> MemoryChoiceMenu:
	return _MemoryChoiceMenuPs.instantiate() as MemoryChoiceMenu
