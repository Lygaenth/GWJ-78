extends CanvasLayer

func _ready():
	%EasierDialogFont.button_pressed = AccessibilitySingleton.IsAccessibilityDialogReadingOn()

func _on_start_button_pressed():
	%StartButtonSound.play()
	PlayerSingleton.Reset()
	await Wait(0.5)
	get_tree().change_scene_to_file("res://ChatRoom/ChatRoom.tscn")


func _on_quit_button_pressed():
	%StartButtonSound.play()
	await Wait(0.5)
	get_tree().quit()

func Wait(time : float):
	await get_tree().create_timer(time).timeout


func _on_audio_settings_mouse_entered():
	%AudioOptionsSettings.show()


func _on_audio_settings_mouse_exited():
	%AudioOptionsSettings.hide()


func _on_music_toggled(toggled_on : bool):
	MusicSingleton.EnableMusic(toggled_on)


func _on_sfx_toggled(toggled_on : bool):
	MusicSingleton.EnableSfx(toggled_on)


func _on_gwj_toggled(toggled_on):
	if (toggled_on):
		%BrackeyCb.button_pressed = false
		%GwjPanel.show()
	else:
		%GwjPanel.hide()


func _on_brackey_toggled(toggled_on):
	if (toggled_on):
		%GwjCb.button_pressed = false
		%BrackeyPanel.show()
	else:
		%BrackeyPanel.hide()

func _on_game_jam_settings_mouse_entered():
	%GameJameOptionsSettings.show()

func _on_game_jam_settings_mouse_exited():
	%GameJameOptionsSettings.hide()

func _on_readability_settings_mouse_entered():
	%ReadabilityOptionsSettings.show()

func _on_readability_settings_mouse_exited():
	%ReadabilityOptionsSettings.hide()

func _on_easier_dialog_font_toggled(toggled_on):
	AccessibilitySingleton.UseAccessibilityDialogReading(toggled_on)


func _on_french_toggled(toggled_on):
	if (toggled_on):
		%EnglishLangToggle.button_pressed = false
		LocalizationSingleton.SetLanguage(Enums.Languages.French)

func _on_english_toggled(toggled_on):
	if (toggled_on):
		%FrenchLangToggled.button_pressed = false
		LocalizationSingleton.SetLanguage(Enums.Languages.English)


func _on_language_settings_mouse_entered():
	%LanguageOptionsSettings.show()

func _on_language_settings_mouse_exited():
	%LanguageOptionsSettings.hide()
