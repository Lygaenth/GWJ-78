extends Label
class_name MoneyLabel

func _ready():
	PlayerSingleton.UpdatedMoney.connect(UpdateMoney)

func UpdateMoney(amount : int):
	text = str("$"+"%06d" % amount)
