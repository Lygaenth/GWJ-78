extends PanelContainer
class_name PatientInformation

@onready var _portrait : TextureRect = $"%Portrait"
@onready var _patientFileLabel : Label = $"%PatientFileLabel"
@onready var _patientNameLabel : Label = $"%PatienNameLabel"
@onready var _patientFirstNameLabel : Label = $"%PatientSurnameLabel"
@onready var _patientBirthdayLabel : Label = $"%PatientBirthDateLabel"
@onready var _patientInfoLabel : Label = $"%PatientInfoLabel"

@export var Character : CharacterBase

func _ready():
	DisplayNothing()

func DisplayPatient(character : CharacterBase):
	Character = character
	if (character == null):
		DisplayWait()
		return
	
	_patientFileLabel.text = "PATIENT_PANEL_CONNECT"
	await Wait(1.0)
		
	_patientFileLabel.text = "PATIENT_PANEL_PATIENT_FILE"
	_portrait.texture = character.Picture
	GetShader().set_shader_parameter("isBugged", false)
	_portrait.show()
	%GreetSound.play()
	
	var tween = get_tree().create_tween()
	tween.tween_property(_portrait, "visible", true, 0.5)
	tween.tween_property(_portrait, "visible", false, 0.02)
	tween.tween_property(_portrait, "visible", true, 0.3)
	
	_patientNameLabel.text = character.FamilyName
	_patientFirstNameLabel.text = character.FirstName
	_patientBirthdayLabel.text = character.BirthDate
	_patientInfoLabel.text = character.Notes
	
func Fry():
	GetShader().set_shader_parameter("isBugged", true)
	%FriedSound.play()

func GetShader() -> ShaderMaterial:
	return _portrait.material as ShaderMaterial

func DisplayCheckingForPatient():
	_patientFileLabel.text = "PATIENT_PANEL_PATIENT_WAITING_1"
	await Wait(0.5)
	_patientFileLabel.text = "PATIENT_PANEL_PATIENT_WAITING_2"
	await Wait(0.5)
	_patientFileLabel.text = "PATIENT_PANEL_PATIENT_WAITING_3"
	await Wait(0.5)
	_patientFileLabel.text = "PATIENT_PANEL_PATIENT_WAITING_4"
	await Wait(0.5)
	_patientFileLabel.text = "PATIENT_PANEL_PATIENT_REQUEST"
	await Wait(1.0)

func DisplayNothing():
	_patientFileLabel.text = ""
	_portrait.hide()
	_portrait.texture = null
	_patientNameLabel.text = ""
	_patientFirstNameLabel.text = ""
	_patientBirthdayLabel.text = ""
	_patientInfoLabel.text = ""
	%CopEye.hide()

func DisplayWait():
	_patientFileLabel.text = "PATIENT_PANEL_PATIENT_LOBBY"
	%PatientWaitingSound.play()
	_portrait.hide()
	_portrait.texture = null
	_patientNameLabel.text = ""
	_patientFirstNameLabel.text = ""
	_patientBirthdayLabel.text = ""
	_patientInfoLabel.text = ""
	
func DisplayCops():
	%CopEye.show()
	_patientFileLabel.text = "???????????"
	_patientNameLabel.text = "WWWWWWWWWWWW"
	_patientFirstNameLabel.text = "WWWWWWWWWWWW"
	_patientBirthdayLabel.text = "??/??/????"
	
func DisplayDeconnection():
	%FriedSound.stop()
	%PatienDisconnect.play()
	DisplayWait()
	_patientFileLabel.text = "PATIENT_PANEL_DISCONNECT"

func Wait(time : float):
	await get_tree().create_timer(time).timeout
