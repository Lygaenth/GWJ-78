extends CanvasLayer
class_name MemsStore

const shopMemoryButtonPs : PackedScene = preload("res://Store/ShopMemoryButton.tscn")

@onready var _buyButton : Button = $"%BuyButton"
@onready var _errorPanel : VBoxContainer = $ErrorPanel

var _selectedItems : Array[MemoryData] = []

signal Closed()

func _ready():
	var memories = MemorySingleton.GetAllMemories()
	
	for memory in memories:
		var button : ShopMemoryButton = shopMemoryButtonPs.instantiate() 
		%GridContainer.add_child(button)
		button.DisplayInShop(memory)
		button.Selected.connect(OnItemStateChanged)
		button.DisplayDescription.connect(OnButtonDisplayDesc)
	CalculateCost()

func Display():
	show()
	PlayerSingleton.ShopUnlock()
	_buyButton.disabled = true

signal SwitchToInventory()


func OnClosePressed():
	%ActionSound.play()
	Closed.emit()
	hide()

func OnItemStateChanged(isSelected : bool, memory : MemoryData):
	if (isSelected):
		_selectedItems.append(memory)
	else:
		_selectedItems.erase(memory)

	CalculateCost()
	_buyButton.disabled = _selectedItems.size() == 0
	
func CalculateCost() -> void:
	if (_selectedItems.size() > 1):
		%ItemNumberLabel.text = str(tr("STORE_ITEMS_NUMBERS") % str(_selectedItems.size()))
	else:
		%ItemNumberLabel.text = str(tr("STORE_ITEMS_NUMBERS_SINGLE") % str(_selectedItems.size()))
	%TotalCostLabel.text = str("$"+"%06d" % GetAmount())

	
func GetAmount() -> int:
	var amount = 0
	for memory in _selectedItems:
		amount += memory.memory_cost
	return amount

func OnBuy():
	%ActionSound.play()
	_buyButton.release_focus()
	if (!PlayerSingleton.BuyMemory(_selectedItems)):
		await NotifyFailedTransaction()
	else:
		for memoryButton : ShopMemoryButton in %GridContainer.get_children():
			if(memoryButton.IsSelected()):
				memoryButton._on_pressed()
		CalculateCost()
	
func ClearSelection():
	_selectedItems.clear()
	_buyButton.disabled = true
	

func NotifyFailedTransaction():
	_errorPanel.show()
	await get_tree().create_timer(1.5).timeout
	_errorPanel.hide()


func _on_inventory_button_pressed():
	%ActionSound.play()
	SwitchToInventory.emit()

func OnButtonDisplayDesc(desc : String):
	%DescLabel.text = desc
