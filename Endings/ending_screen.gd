extends CanvasLayer
class_name EndingsScreen

func RaiseEnding(ending : Enums.Endings) -> void:
	match ending:
		Enums.Endings.NoMorescenario:
			%NoMoreScenarioEnding.show()
		Enums.Endings.TooManyMistakes:
			%TooManyMistakesEnding.show()

	show()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
