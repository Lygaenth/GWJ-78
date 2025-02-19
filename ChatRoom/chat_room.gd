extends CanvasLayer
class_name ChatRoom

@onready var _patientDialog : Label = $"%PatientDialog"
@onready var _doctorDialog : Label = $"%DoctorDialog"
@onready var _patientInfo : PatientInformation = $"%PatientInfo"
@onready var _payLabel : MoneyLabel = $"%MoneyLabel"
@onready var _gainLabel : PayLabel = $"%PayLabel"
@onready var _shopButton : AttractAttentionButton = $"%ShopBtn"
@onready var _jackInButton : AttractAttentionButton = $"%JackInBtn"
@onready var _greetButton : AttractAttentionButton = $"%GreetBtn"
@onready var _store : MemsStore = $Store
@onready var _endingsScreen : EndingsScreen = $EndingScreen

@onready var _operationRoomFactory : OperationRoomFactory = $OperationRoomFactory
@onready var _talkers : Array[AudioStreamPlayer]

var _gameState : Enums.GameState = Enums.GameState.CheckEvent
var _scenario : ScenarioBase
var _operationRoom : OperationRoom
	
func _ready():
	_talkers = [%TalkSound, %Talk2Sound, %Talk3Sound]
	PlayerSingleton.UpdateMoney(0)
	
	await Wait(1.0)
	await _patientInfo.DisplayCheckingForPatient()
	_gameState = Enums.GameState.WaitingForPatient
	_patientInfo.DisplayWait()
	EnableGreetButton()

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
			await Wait(0.5)
			var pay = _scenario.GetPay()
			if pay > 0:
				await DisplayPay(pay)
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
	
	TalkRandom()
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
	if (!PlayerSingleton.IsConnectLock()):
		_jackInButton.disabled = false
		_jackInButton.Attract()

func EnableShopping():
	if (!PlayerSingleton.IsShopLock()):
		_shopButton.disabled = false

func DisableJacking():
	_jackInButton.Stop()
	_jackInButton.disabled = true

func DisableShopping():
	_shopButton.disabled = true

func LoadNextScenario() -> bool:
	_scenario = PlayerSingleton.GetNextScenario()
	EnableShopping()
	if (_scenario != null):
		_patientInfo.DisplayPatient(_scenario.Patient)
	else:
		_patientInfo.DisplayWait()
		DisplayEnding(Enums.Endings.NoMorescenario)

	return _scenario != null

func DisplayPay(pay : int):
	%PayStart.play()
	_gainLabel.UpdateMoney(pay)
	_gainLabel.Display()
	await Wait(2.0)
	_gainLabel.Hide()
	PlayerSingleton.UpdateMoney(pay)
	
func DisplayPatientDepart():
	_patientInfo.DisplayDeconnection()
	
func CheckEvent() -> bool:
	PlayerSingleton.UnlockShop()
	EnableShopping()
	var errors = PlayerSingleton.GetCharactersError()
	if (errors.size() >= 3):
		DisplayEnding(Enums.Endings.TooManyMistakes)
		return true
	
	return false

func OnShopPressed():
	%ClickSound.play()
	_shopButton.release_focus()
	_store.show()
	PlayerSingleton.ShopUnlock()
	if (_scenario.GetState() == Enums.ScenarioState.Operation):
		EnableShoppingAndJacking()

func OnJackPressed():
	%ClickSound.play()	
	_jackInButton.release_focus()
	if (_gameState == Enums.GameState.OnGoingScenario):
		DisableJacking()
		StartOperation()

func StartOperation():
	_gameState = Enums.GameState.OperatingPatient
	_operationRoom = _operationRoomFactory.CreateOperationRoom(_scenario.GetMemories())
	add_child(_operationRoom)
	MusicSingleton.SwitchToOperationMusic()
	_operationRoom.confirm_operation.connect(OnOperationTerminated)
	
func OnOperationTerminated(modifiedMemories : Array[MemoryData]):
	MusicSingleton.SwitchToMainMusic()
	var isFried = _scenario.ResolveAndCheckIfFried(modifiedMemories)
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
	%ClickSound.play()
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

func TalkRandom():
	var talkerIndex = randi_range(0,2)
	_talkers[talkerIndex].play()


func _on_inventory_pressed():
	%Inventory.Display()


func _on_store_switch_to_inventory():
	%Inventory.show()
	_store.hide()


func _on_inventory_switch_to_store():
	_store.show()
	%Inventory.hide()
	PlayerSingleton.ShopUnlock()
	if (_scenario.GetState() == Enums.ScenarioState.Operation):
		EnableShoppingAndJacking()
