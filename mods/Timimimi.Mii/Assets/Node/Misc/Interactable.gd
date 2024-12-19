extends Interactable

#export var text = "INTERACT"
signal _open
signal _close
func _ready():
	#monitoring = false
	#add_to_group("interactable")
	pass
func _activate(actor):
	emit_signal("_open")

func _closed():
	emit_signal("_close")
