extends CanvasLayer
class_name ChatRoom

@onready var _patientDialog : Label = $"%PatientDialog"
@onready var _doctorDialog : Label = $"%DoctorDialog"
@onready var _patientInfo : PatientInformation = $"%PatientInfo"
@onready var _payLabel : MoneyLabel = $"%MoneyLabel"
@onready var _gainLabel : MoneyLabel = $"%PayLabel"
@onready var _shopButton : AttractAttentionButton = $"%ShopBtn"
@onready var _jackInButton : AttractAttentionButton = $"%JackInBtn"
@onready var _greetButton : AttractAttentionButton = $"%GreetBtn"
@onready var _store : MemsStore = $Store
@onready var _endingsScreen : EndingsScreen = $EndingScreen

@onready var _operationRoomFactory : OperationRoomFactory = $OperationRoomFactory

var _gameState : Enums.GameState = Enums.GameState.WaitingForPatient
var _scenario : ScenarioBase
var _operationRoom : OperationRoom
	
func _ready():
	PlayerSingleton.UpdateMoney(0)
	EnableGreetButton()
	EnableShopping()

func _process(delta):
	if (Input.is_action_just_pressed("Next")):
		Next()

func Next():
	if (_gameState == Enums.GameState.OnGoingScenario):
		var scenarioState = _scenario.GetState() 
		if (scenarioState == Enums.ScenarioState.Opening 
			|| scenarioState == Enums.ScenarioState.Closing
			|| scenarioState == Enums.ScenarioState.Frying):
			DisplayLine(_scenario.GetLine())
		elif (scenarioState == Enums.ScenarioState.Operation):
			HideDialog()
			EnableShoppingAndJacking()
		elif (scenarioState == Enums.ScenarioState.OperationResult):
			DisableJacking()
			await DisplayPay(_scenario.GetPay())
		elif (scenarioState == Enums.ScenarioState.Closed):
			HideDialog()
			DisplayPatientDepart()
			_gameState = Enums.GameState.CheckEvent
			var eventBlocking = await CheckEvent()
			if(eventBlocking):
				return
				
			await Wait(2.0)
			_patientInfo.DisplayWait()
			_gameState = Enums.GameState.WaitingForPatient
			EnableGreetButton()
			
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
		_patientDialog.label_settings.font = _scenario.Patient.TalkFont
		_patientDialog.show()
	elif line.Talker == Enums.Talker.Doctor:
		_patientDialog.hide()
		_doctorDialog.text = line.Text
		_doctorDialog.show()

func EnableShoppingAndJacking():
	_jackInButton.disabled = false
	_jackInButton.Attract()

func EnableShopping():
	_shopButton.disabled = false
	_shopButton.Attract()

func DisableJacking():
	_jackInButton.Stop()
	_jackInButton.disabled = true

func DisableShopping():
	_shopButton.disabled = true

func LoadNextScenario() -> bool:
	_scenario = PlayerSingleton.GetNextScenario()
	if (_scenario != null):
		_patientInfo.DisplayPatient(_scenario.Patient)
	else:
		_patientInfo.DisplayWait()
		DisplayEnding(Enums.Endings.NoMorescenario)

	return _scenario != null

func DisplayPay(pay : int):
	_gainLabel.UpdateMoney(pay)
	_gainLabel.show()
	await Wait(2.0)
	_gainLabel.hide()
	PlayerSingleton.UpdateMoney(pay)
	
func DisplayPatientDepart():
	_patientInfo.DisplayDeconnection()
	
func CheckEvent() -> bool:
	var errors = PlayerSingleton.GetCharactersError()
	if (errors.size() >= 3):
		DisplayEnding(Enums.Endings.TooManyMistakes)
		return true
	
	return false

func OnShopPressed():
	_store.show()
	_shopButton.Stop()
	_shopButton.release_focus()

func OnJackPressed():
	_jackInButton.release_focus()
	if (_gameState == Enums.GameState.OnGoingScenario):
		DisableJacking()
		StartOperation()

func StartOperation():
	_gameState = Enums.GameState.OperatingPatient
	_operationRoom = _operationRoomFactory.CreateOperationRoom(_scenario.GetMemories())
	add_child(_operationRoom)
	_operationRoom.confirm_operation.connect(OnOperationTerminated)
	
func OnOperationTerminated(modifiedMemories : OperationData):
	var isFried = _scenario.ResolveAndCheckIfFried(modifiedMemories.memory_data_array)
	_operationRoom.queue_free()
	_gameState = Enums.GameState.OnGoingScenario
	if (isFried):
		_patientInfo.Fry()
	else:
		await Next()

	await Next()
	EnableShopping()

func EnableGreetButton() -> void:
	_greetButton.disabled = false
	_greetButton.Attract()

func DisableGreeButton() -> void:
	_greetButton.disabled = true
	_greetButton.Stop()

func OnGreetPressed() -> void:
	if (_gameState == Enums.GameState.WaitingForPatient):
		DisableGreeButton()
		if(LoadNextScenario()):		
			await Wait(1.0)
			_gameState = Enums.GameState.OnGoingScenario
			Next()

func Wait(time : float):
	await get_tree().create_timer(time).timeout

func DisplayEnding(ending : Enums.Endings):
	_gameState = Enums.GameState.Ending
	DisableJacking()
	DisableGreeButton()
	DisableShopping()
	_endingsScreen.RaiseEnding(ending)
