extends Node
class_name DialogLine

@export var Talker : Enums.Talker = Enums.Talker.Patient
@export var Text : String = ""

func Init(talker : Enums.Talker, text : String) -> void:
	Talker = talker
	Text = text
