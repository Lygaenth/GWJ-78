extends Label

func _ready():
	PlayerSingleton.UpdatedMoney.connect(UpdateMoney)

func UpdateMoney(amount : int):
	text = str("$"+"%06d" % amount)
