extends Area2D
## Portal genérico para cambiar de escena con E o clic.

@export var next_scene: PackedScene        # Asigna aquí la escena destino (*.tscn)
@export var require_proximity := true      # Exige estar dentro del área
@export var click_enabled := true          # Permite clic con mouse

var player_inside := false

func _ready() -> void:
	monitoring = true
	input_pickable = true
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
	if not input_event.is_connected(_on_input_event):
		input_event.connect(_on_input_event)

func _on_body_entered(body: Node) -> void:
	if _is_player(body):
		player_inside = true

func _on_body_exited(body: Node) -> void:
	if _is_player(body):
		player_inside = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interactuar") and (player_inside or not require_proximity):
		_travel()

func _on_input_event(_viewport, event: InputEvent, _shape_idx: int) -> void:
	if click_enabled and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if player_inside or not require_proximity:
			_travel()

func _travel() -> void:
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
	else:
		push_error("Asigna una escena en 'next_scene' en el Inspector.")

func _is_player(n: Node) -> bool:
	return n.is_in_group("player") or n.is_in_group("jugador") or n.name in ["Player","player","Jugador"]
