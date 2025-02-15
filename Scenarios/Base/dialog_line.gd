extends Node
class_name DialogLine

var Talker : Enums.Talker = Enums.Talker.Patient
var Text : String = ""

func Init(talker : Enums.Talker, text : String) -> void:
	Talker = talker
	Text = text
