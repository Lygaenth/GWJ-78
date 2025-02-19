extends PanelContainer

var counter = 0
func _process(delta):
	counter += delta
	if (counter < 0.5):
		modulate = Color(255, 255, 255, 255)
	
	if (counter > 0.5):
		modulate = Color(0, 255, 255, 255)
		
	if (counter > 1.0):
		counter = 0
