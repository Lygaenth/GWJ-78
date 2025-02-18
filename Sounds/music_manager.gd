extends Node
class_name MusicManager

func _ready():
	print("0: "+AudioServer.get_bus_name(0))
	print("1: "+AudioServer.get_bus_name(1))
	print("2: "+AudioServer.get_bus_name(2))

func SwitchToOperationMusic():
	AudioServer.set_bus_mute(2, false)
	AudioServer.set_bus_mute(1, true)
	%TransitionSound.play()
	
func SwitchToMainMusic():
	AudioServer.set_bus_mute(1, false)
	AudioServer.set_bus_mute(2, true)
	%TransitionSound.play()
