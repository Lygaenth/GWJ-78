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
	
	_patientFileLabel.text = "Connecting..."
	await Wait(1.0)
		
	_patientFileLabel.text = "Patient file:"
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
	_patientFileLabel.text = "Waiting for patient"
	await Wait(0.5)
	_patientFileLabel.text = "Waiting for patient."
	await Wait(0.5)
	_patientFileLabel.text = "Waiting for patient.."
	await Wait(0.5)
	_patientFileLabel.text = "Waiting for patient..."
	await Wait(0.5)
	_patientFileLabel.text = "Patient found !"
	await Wait(1.0)

func DisplayNothing():
	_patientFileLabel.text = ""
	_portrait.hide()
	_portrait.texture = null
	_patientNameLabel.text = ""
	_patientFirstNameLabel.text = ""
	_patientBirthdayLabel.text = ""
	_patientInfoLabel.text = ""

func DisplayWait():
	_patientFileLabel.text = "A patient is waiting..."
	%PatientWaitingSound.play()
	_portrait.hide()
	_portrait.texture = null
	_patientNameLabel.text = ""
	_patientFirstNameLabel.text = ""
	_patientBirthdayLabel.text = ""
	_patientInfoLabel.text = ""
	
func DisplayDeconnection():
	%FriedSound.stop()
	DisplayWait()
	_patientFileLabel.text = "Disconnecting..."

func Wait(time : float):
	await get_tree().create_timer(time).timeout
