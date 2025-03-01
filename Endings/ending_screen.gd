extends CanvasLayer
class_name EndingsScreen

func RaiseEnding(ending : Enums.Endings) -> void:
	var playedSecenariosResult = tr("ENDINGS_COMPLETION_RATE").format([str(PlayerSingleton.GetPlayedScenarioCount()), "11"])
	%NoMoreScenarioResult.text = playedSecenariosResult
	%ScenarioResultAI.text = playedSecenariosResult
	%TooManyErrorsResult.text = playedSecenariosResult
	match ending:
		Enums.Endings.NoMorescenario:
			%NoMoreScenarioEnding.show()
		Enums.Endings.TooManyMistakes:
			%TooManyMistakesEnding.show()
		Enums.Endings.AiDooming:
			%AiEnding.show()

	show()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
