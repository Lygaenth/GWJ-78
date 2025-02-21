extends Node
class_name MusicManager

func _ready():
	print("0: "+AudioServer.get_bus_name(0))
	print("1: "+AudioServer.get_bus_name(1))
	print("2: "+AudioServer.get_bus_name(2))

func SwitchToOperationMusic(withTransition : bool = true):
	AudioServer.set_bus_mute(2, false)
	AudioServer.set_bus_mute(1, true)
	
func SwitchToMainMusic(withTransition : bool = true):
	AudioServer.set_bus_mute(1, false)
	AudioServer.set_bus_mute(2, true)
	if withTransition:
		%TransitionSound.play()

func DisableAllMusic():
	AudioServer.set_bus_mute(1, true)
	AudioServer.set_bus_mute(2, true)


func EnableMusic(on : bool):
	if (on):
		SwitchToMainMusic(false)
	else:
		DisableAllMusic()
		
func EnableSfx(on : bool):
	AudioServer.set_bus_mute(3, on)
	if (on):
		%TestSound.play()
