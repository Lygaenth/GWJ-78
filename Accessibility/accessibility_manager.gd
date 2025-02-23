extends Node
class_name AccessibilityManager

var _isEasyReadinOn : bool = false
var _accessibilityFont : Font = load("res://Fonts/Andika-Regular.ttf")

func UseAccessibilityDialogReading(on : bool) -> void:
	_isEasyReadinOn = on
	
func IsAccessibilityDialogReadingOn() -> bool:
	return _isEasyReadinOn

func GetAccessibilityFont() -> Font:
	return _accessibilityFont
