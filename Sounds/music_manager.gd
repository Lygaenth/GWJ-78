extends Node
class_name MusicManager

func _ready():
	%MainMusicPlayer.volume_db = _musicVolumeRef
	%OperationRoomMusicPlayer.volume_db = _cutOffVolume

var _musicVolumeRef : float = -6.0
var _cutOffVolume : float = -124.0
var _sfxVolumeRef : float = 0

var volumeMusic : float = _musicVolumeRef
var volumeSfx : float = _sfxVolumeRef

func SwitchToOperationMusic():
	%MainMusicPlayer.volume_db = _cutOffVolume
	%OperationRoomMusicPlayer.volume_db = _musicVolumeRef
	
func SwitchToMainMusic(withTransition : bool = true):
	%MainMusicPlayer.volume_db = _musicVolumeRef
	%OperationRoomMusicPlayer.volume_db = _cutOffVolume
	if withTransition:
		%TransitionSound.play()

func DisableAllMusic():
	%MainMusicPlayer.volume_db = _cutOffVolume
	%OperationRoomMusicPlayer.volume_db = _cutOffVolume


func EnableMusic(on : bool):
	if (on):
		SwitchToMainMusic(false)
	else:
		DisableAllMusic()
		
func EnableSfx(on : bool):
	if (on):
		volumeSfx = _sfxVolumeRef
		%TestSound.play()
	else:
		volumeSfx = _cutOffVolume
	SfxUpdated.emit(volumeSfx)


func GetSfxVolume() -> float:
	return volumeSfx

signal SfxUpdated(newVolume : float)
