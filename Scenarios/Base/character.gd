extends Node
class_name CharacterBase

@export var FamilyName : String = ""
@export var FirstName : String = ""
@export var BirthDate : String = ""
@export var Notes: String = ""
@export var Picture : Texture2D = preload("res://icon.svg")
@export var TalkFont : Font = null

func GetFullName() -> String:
	return FirstName +" "+FamilyName

func Fix() -> void:
	pass
