class_name LocalizationManager extends Node

func _ready():
	SetLanguage(Enums.Languages.English)

func SetLanguage(language : Enums.Languages):
	TranslationServer.set_locale(_convertEnumToCode(language))
	
	
func _convertEnumToCode(language : Enums.Languages):
	match language:
		Enums.Languages.English:
			return "en"
		Enums.Languages.French:
			return "fr"
	return "en"
