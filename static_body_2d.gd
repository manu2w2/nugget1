extends StaticBody2D

@onready var area: Area2D = $Area2D
var jugador_cerca := false

func _ready() -> void:
	if area:
		if not area.body_entered.is_connected(_on_body_entered):
			area.body_entered.connect(_on_body_entered)
		if not area.body_exited.is_connected(_on_body_exited):
			area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") or body.is_in_group("jugador"):
		jugador_cerca = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player") or body.is_in_group("jugador"):
		jugador_cerca = false

func _process(_delta: float) -> void:
	pass
