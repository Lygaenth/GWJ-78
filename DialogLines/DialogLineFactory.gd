extends Node
class_name  DialogLineFactory

const _dialogLinePs : PackedScene = preload("res://Scenarios/Base/DialogLine.tscn")

static func CreateLine(talker : Enums.Talker, content : String) -> DialogLine:
	var line : DialogLine = _dialogLinePs.instantiate()
	line.Init(talker, content)
	return line
