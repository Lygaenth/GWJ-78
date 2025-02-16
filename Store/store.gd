extends CanvasLayer
class_name MemsStore

const shopMemoryButtonPs : PackedScene = preload("res://Store/ShopMemoryButton.tscn")

var _amount : int = 0
var _numberOfSelectedItem : int = 0
var _selectedItems : Array[MemoryData] = []

func _ready():
	var memories = MemorySingleton.GetAllMemories()
	
	for memory in memories:
		var button : ShopMemoryButton = shopMemoryButtonPs.instantiate() 
		%GridContainer.add_child(button)
		button.DisplayInShop(memory)
		button.Selected.connect(OnItemStateChanged)

func Display():
	show()

func OnClosePressed():
	hide()

func OnItemStateChanged(isSelected : bool, memory : MemoryData):
	if (isSelected):
		_selectedItems.append(memory)
	else:
		_selectedItems.erase(memory)
	
	%ItemNumberLabel.text = str(_selectedItems.size())+" item(s) selected"
	%TotalCostLabel.text = str("$"+"%06d" % GetAmount())
	
func GetAmount() -> int:
	var amount = 0
	for memory in _selectedItems:
		amount += memory.memory_cost
	return amount

func OnBuy():
	if (!PlayerSingleton.BuyMemory(_selectedItems)):
		NotifyFailedTransaction()
	else:
		for memoryButton : ShopMemoryButton in %GridContainer.get_children():
			if (memoryButton.IsSelected()):
				memoryButton.queue_free()


func NotifyFailedTransaction():
	pass
