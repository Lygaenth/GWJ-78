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
	DisplayPatient(Character)

func DisplayPatient(character : CharacterBase):
	Character = character
	if (character == null):
		DisplayWait()
		return
		
	_patientFileLabel.text = "Patient file:"
	_portrait.texture = character.Picture
	_portrait.show()
	_patientNameLabel.text = character.FamilyName
	_patientFirstNameLabel.text = character.FirstName
	_patientBirthdayLabel.text = character.BirthDate
	_patientInfoLabel.text = character.Notes

func DisplayWait():
	_patientFileLabel.text = "A patient is waiting"
	_portrait.hide()
	_portrait.texture = null
	_patientNameLabel.text = ""
	_patientFirstNameLabel.text = ""
	_patientBirthdayLabel.text = ""
	_patientInfoLabel.text = ""
	
func DisplayDeconnection():
	DisplayWait()
	_patientFileLabel.text = "Disconnecting..."
