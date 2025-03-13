extends Node
class_name MusicManager

func _ready():
	%MainMusicPlayer.volume_db = _musicVolumeRef
	%OperationRoomMusicPlayer.volume_db = _cutOffVolume

var _musicVolumeRef : float = -6.0
var _cutOffVolume : float = -124.0
var _sfxVolumeRef : float = 0

var _musicOn : bool = true
var _mainMusicOn : bool = true
var _sfxOn : bool = true
var _volumeMusic : float = _musicVolumeRef
var _volumeSfx : float = _sfxVolumeRef

func SwitchToOperationMusic():
	_mainMusicOn = false
	if (_musicOn):
		%MainMusicPlayer.volume_db = _cutOffVolume
		%OperationRoomMusicPlayer.volume_db = _volumeMusic

func SwitchToMainMusic(withTransition : bool = true):
	_mainMusicOn = true
	if(_musicOn):
		%MainMusicPlayer.volume_db = _musicVolumeRef
		%OperationRoomMusicPlayer.volume_db = _cutOffVolume
		if withTransition:
			%TransitionSound.play()

func DisableAllMusic():
	_musicOn = false
	%MainMusicPlayer.volume_db = _cutOffVolume
	%OperationRoomMusicPlayer.volume_db = _cutOffVolume


func EnableMusic(on : bool):
	if (on):
		_musicOn = true
		SwitchToMainMusic(false)
	else:
		DisableAllMusic()
		
func EnableSfx(on : bool):
	if (on):
		_sfxOn = true
		SfxUpdated.emit(_volumeSfx)
		%TestSound.play()
	else:
		SfxUpdated.emit(_cutOffVolume)

func UpdateMusicVolume(volume : float) -> void:
	_volumeMusic = linear_to_db(volume) + _musicVolumeRef
	if(_musicOn):
		if (_mainMusicOn):
			%MainMusicPlayer.volume_db = _volumeMusic
		else:
			%OperationRoomMusicPlayer.volume_db = _volumeMusic

func UpdateSfxVolume(volume : float) -> void:
	_volumeSfx = linear_to_db(volume) + _musicVolumeRef
	SfxUpdated.emit(_volumeSfx)

func GetSfxVolume() -> float:
	return _volumeSfx

func PlayTestSound():
	%TestSound.play()

signal SfxUpdated(newVolume : float)
