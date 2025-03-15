extends CanvasLayer
class_name ChatRoom

@onready var _patientDialog : CharacterDialog = $"%PatientDialog"
@onready var _doctorDialog : CharacterDialog = $"%DoctorDialog"
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

var _inMenus: bool = false

var _gameState : Enums.GameState = Enums.GameState.CheckEvent
var _scenario : ScenarioBase
var _operationRoom : OperationRoom
var _waitingForEoL : bool = false

func _ready():
	_talkers = [%TalkSound, %Talk2Sound, %Talk3Sound]
	_store.Closed.connect(OnQuittedMenus)
	%Inventory.Closed.connect(OnQuittedMenus)
	PlayerSingleton.UpdateMoney(0)

	_doctorDialog.CompletedLine.connect(ResetEoLWait)
	_patientDialog.CompletedLine.connect(ResetEoLWait)
	
	await Wait(1.0)
	await _patientInfo.DisplayCheckingForPatient()
	_gameState = Enums.GameState.WaitingForPatient
	_patientInfo.DisplayWait()
	EnableGreetButton()
	%DebugLabel.text = PlayerSingleton._scenarioProvider._logs

func OnQuittedMenus():
	_inMenus = false

func _process(_delta):
	if (Input.is_action_just_pressed("Next")):
		Next()

func ResetEoLWait():
	_waitingForEoL = false

func Next():
	if (_inMenus):
		return
	
	if (_waitingForEoL):
		_doctorDialog.ForceComplete()
		_patientDialog.ForceComplete()
		_waitingForEoL = false
		return
	
	if (_gameState == Enums.GameState.BadEndingPreparation):
		%DebugLabel.text = "Bad ending action"
		var line = PlayerSingleton.ErrorManager.GetCopLines()
		if (line == null):
			DisplayEnding(Enums.Endings.TooManyMistakes)
		else:
			DisplayLine(line)
		return
		
	if (_gameState == Enums.GameState.OnGoingScenario):
		var scenarioState = _scenario.GetState() 
		if (scenarioState == Enums.ScenarioState.Opening 
			|| scenarioState == Enums.ScenarioState.Closing
			|| scenarioState == Enums.ScenarioState.Frying):
			var line = _scenario.GetLine()
			DisplayLine(line)
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
	%DebugLabel.text = "display line: "+line.Text
	if (line == null || line.Talker == Enums.Talker.None):
		HideDialog()
		return
		
	_waitingForEoL = true
	TalkRandom()
	if (line.Talker == Enums.Talker.Patient):
		_doctorDialog.hide()
		_patientDialog.DisplayLine(line.Text)
		if (!AccessibilitySingleton.IsAccessibilityDialogReadingOn()):
			_patientDialog.label_settings.font = _scenario.Patient.TalkFont
		else:
			_patientDialog.label_settings.font = AccessibilitySingleton.GetAccessibilityFont()
		_patientDialog.show()
	elif line.Talker == Enums.Talker.Doctor:
		_patientDialog.hide()
		if (AccessibilitySingleton.IsAccessibilityDialogReadingOn()):
			_doctorDialog.label_settings.font = AccessibilitySingleton.GetAccessibilityFont()
			_doctorDialog.custom_minimum_size.y = 250
		_doctorDialog.DisplayLine(line.Text)
		_doctorDialog.show()

func EnableShoppingAndJacking():
	if (!PlayerSingleton.IsConnectLock()):
		_jackInButton.disabled = false
		_jackInButton.Attract()

func EnableShopping():
	if (!PlayerSingleton.IsShopLock()):
		_shopButton.disabled = false
		if (PlayerSingleton.IsConnectLock()):
			_shopButton.Attract()

func DisableJacking():
	_jackInButton.Stop()
	_jackInButton.disabled = true

func DisableShopping():
	_shopButton.disabled = true

func LoadNextScenario() -> bool:
	%DebugLabel.text = "loading scenario"
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
	DisableJacking()
	if (PlayerSingleton.ErrorManager.HasTooManyError()):
		_gameState = Enums.GameState.BadEndingPreparation
		MusicSingleton.SwitchToOperationMusic()
		_patientInfo.DisplayCops()
		return true
	
	if (PlayerSingleton.ErrorManager.HasReleasedAnAi()):
		_gameState = Enums.GameState.Ending
		MusicSingleton.SwitchToOperationMusic()
		DisplayEnding(Enums.Endings.AiDooming)
		return true		
	
	return false

func OnShopPressed():
	%ClickSound.play()
	_inMenus = true
	_shopButton.release_focus()
	_store.show()
	PlayerSingleton.ShopUnlock()
	_shopButton.Stop()
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
	_operationRoom.OpenShop.connect(OnShopPressed)
	_operationRoom.OpenInventory.connect(_on_inventory_pressed)
	add_child(_operationRoom)
	MusicSingleton.SwitchToOperationMusic()
	DisableJacking()
	_operationRoom.confirm_operation.connect(OnOperationTerminated)
	
func OnOperationTerminated(modifiedMemories : Array[MemoryData]):
	MusicSingleton.SwitchToMainMusic()
	var isFried = _scenario.ResolveAndCheckIfFried(modifiedMemories)
	_operationRoom.queue_free()
	_gameState = Enums.GameState.OnGoingScenario
	if (isFried):
		_patientInfo.Fry()
	else:
		_patientInfo.Character.Fix()
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
			%DebugLabel.text = "tempo before starting"
			await Wait(1.0)
			_gameState = Enums.GameState.OnGoingScenario
			%DebugLabel.text = "Going into next"
			Next()

func Wait(time : float):
	await get_tree().create_timer(time).timeout

func DisplayEnding(ending : Enums.Endings):
	_gameState = Enums.GameState.Ending
	DisableJacking()
	DisableGreeButton()
	DisableShopping()
	_inMenus = true
	_endingsScreen.RaiseEnding(ending)

func TalkRandom():
	var talkerIndex = randi_range(0,2)
	_talkers[talkerIndex].play()

func _on_inventory_pressed():
	%Inventory.Display()
	_inMenus = true

func _on_store_switch_to_inventory():
	%Inventory.show()
	_store.hide()
	_inMenus = true

func _on_inventory_switch_to_store():
	_store.show()
	%Inventory.hide()
	PlayerSingleton.ShopUnlock()
	_shopButton.Stop()
	if (_scenario.GetState() == Enums.ScenarioState.Operation):
		EnableShoppingAndJacking()
	_inMenus = true

func _on_resign_button_pressed():
	%QuitConfirm.show()
	_inMenus = true

func _on_quit_button_pressed():
	PlayerSingleton.Reset()
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")

func _on_cancel_button_pressed():
	%QuitConfirm.hide()
	_inMenus = false
