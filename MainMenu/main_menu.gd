extends CanvasLayer


func _on_start_button_pressed():
	%StartButtonSound.play()
	(%Background.material as ShaderMaterial).set_shader_parameter("_isActive", true)
	await Wait(1.0)
	get_tree().change_scene_to_file("res://ChatRoom/ChatRoom.tscn")


func _on_quit_button_pressed():
	get_tree().quit()

func Wait(time : float):
	await get_tree().create_timer(time).timeout
