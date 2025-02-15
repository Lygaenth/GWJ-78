extends CanvasLayer
class_name MemsStore

var _amount : int = 0
var _numberOfSelectedItem : int = 0
var _selectedItems : Array[MemoryData] = []

func _ready():
	for button : ShopMemoryButton in %GridContainer.get_children():
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
	pass
