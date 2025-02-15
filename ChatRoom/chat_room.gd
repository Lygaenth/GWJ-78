extends CanvasLayer
class_name ChatRoom

@onready var _patientDialog : Label = $"%PatientDialog"
@onready var _doctorDialog : Label = $"%DoctorDialog"
@onready var _scenarioFactory : ScenarioFactory = $ScenarioFactory
@onready var _patientInfo : PatientInformation = $"%PatientInfo"

var _gameState : Enums.GameState = Enums.GameState.WaitingForPatient
var _scenario : ScenarioBase

func _ready():
	pass
	
func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")):
		Next()

func Next():
	if (_gameState == Enums.GameState.WaitingForPatient):
		LoadNextScenario()
		_gameState = Enums.GameState.OnGoingScenario
		return
		
	if (_gameState == Enums.GameState.OnGoingScenario):
		var scenarioState = _scenario.GetState()
		if (scenarioState == Enums.ScenarioState.Opening || scenarioState == Enums.ScenarioState.Closing):
			DisplayLine(_scenario.GetLine())
		elif (scenarioState == Enums.ScenarioState.Operation):
			HideDialog()
			_scenario.Resolve(0)
		elif (scenarioState == Enums.ScenarioState.OperationResult):
			DisplayPay(_scenario.GetPay())
		elif (scenarioState == Enums.ScenarioState.Closed):
			HideDialog()
			DisplayPatientDepart()
			_gameState = Enums.GameState.CheckEvent
			CheckEvent()
			_gameState = Enums.GameState.WaitingForPatient
			
func HideDialog():
	_patientDialog.hide()
	_doctorDialog.hide()
			
func DisplayLine(line : DialogLine):
	if (line == null || line.Talker == Enums.Talker.None):
		HideDialog()
		return
	
	if (line.Talker == Enums.Talker.Patient):
		_doctorDialog.hide()
		_patientDialog.text = line.Text
		_patientDialog.show()
	elif line.Talker == Enums.Talker.Doctor:
		_patientDialog.hide()
		_doctorDialog.text = line.Text
		_doctorDialog.show()

func LoadNextScenario():
	_scenario = _scenarioFactory.GetNextScenario()
	if (_scenario != null):
		_patientInfo.DisplayPatient(_scenario.Patient)
	else:
		_patientInfo.DisplayWait()
	
func DisplayPay(pay : int):
	pass
	
func DisplayPatientDepart():
	_patientInfo.DisplayDeconnection()
	
func CheckEvent():
	await get_tree().create_timer(2.0).timeout
	_patientInfo.DisplayWait()
