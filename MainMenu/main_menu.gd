extends CanvasLayer


func _on_start_button_pressed():
	%StartButtonSound.play()
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
