extends AudioStreamPlayer

func _ready():
	volume_db = MusicSingleton.GetSfxVolume()
	MusicSingleton.SfxUpdated.connect(UpdateVolume)

func UpdateVolume(volume : float):
	volume_db = volume
