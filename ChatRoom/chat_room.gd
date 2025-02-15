extends CanvasLayer
class_name ChatRoom

@onready var _patientDialog : Label = $"%PatientDialog"
@onready var _doctorDialog : Label = $"%DoctorDialog"
@onready var _patientInfo : PatientInformation = $"%PatientInfo"
@onready var _payLabel : Label = $"%MoneyLabel"
@onready var _shopButton : Button = $"%ShopBtn"
@onready var _jackInButton : Button = $"%JackInBtn"

@onready var _operationRoomFactory = $OperationRoomFactory

var _gameState : Enums.GameState = Enums.GameState.WaitingForPatient
var _scenario : ScenarioBase
	
func _ready():
	PlayerSingleton.UpdateMoney(0)

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
			EnableShoppingAndJacking()

		elif (scenarioState == Enums.ScenarioState.OperationResult):
			EnableShoppingAndJacking()
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

func EnableShoppingAndJacking():
	_jackInButton.disabled = false
	_shopButton.disabled = false

func DisableShoppingAndJacking():
	_jackInButton.disabled = true
	_shopButton.disabled = true

func LoadNextScenario():
	_scenario = PlayerSingleton.GetNextScenario()
	if (_scenario != null):
		_patientInfo.DisplayPatient(_scenario.Patient)
	else:
		_patientInfo.DisplayWait()
	
func DisplayPay(pay : int):
	var label = Label.new()
	label.label_settings = load("res://ChatRoom/Assets/PatientTextDialog.tres")

	label.global_position = Vector2(1600, 850)
	call_deferred("add_child", label)
	
	await get_tree().create_timer(1.0)
	label.queue_free()
	
	PlayerSingleton.UpdateMoney(pay)
	
	await get_tree().create_timer(2.0).timeout
	pass
	
func DisplayPatientDepart():
	_patientInfo.DisplayDeconnection()
	
func CheckEvent():
	await get_tree().create_timer(2.0).timeout
	_patientInfo.DisplayWait()

func OnShopPressed():
	print("Open shop")
	_shopButton.release_focus()

func OnJackPressed():
	
	var operationRoom = _operationRoomFactory.CreateOperationRoom(_scenario.GetMemories())
	add_child(operationRoom)
	
	await get_tree().create_timer(2.0).timeout
	operationRoom.queue_free()

	_scenario.Resolve(0)
	_jackInButton.release_focus()
