extends CharacterBody2D

@export var speed: float = 200.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var ui_label = $"../CanvasLayer/ui/Label"
@onready var black_screen = $"../CanvasLayer/ui/ColorRect"

var last_anim: String = "Abajo"
var near_van: bool = false
var waiting_for_confirm: bool = false

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir * speed
	move_and_slide()
	_animate(dir)

	# Detección de interacción (usa la tecla E configurada como "interactuar")
	if Input.is_action_just_pressed("interactuar"):
		if near_van:
			if not waiting_for_confirm:
				ui_label.text = "¿Te irás de viaje? Presiona E otra vez para aceptar."
				ui_label.visible = true
				waiting_for_confirm = true
			else:
				start_trip()

func _animate(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		anim.stop()
		anim.animation = last_anim
		anim.frame = 1
		return

	if abs(dir.x) > abs(dir.y):
		if dir.x > 0.0:
			last_anim = "Derecha"
		else:
			last_anim = "Izquierda"
	else:
		if dir.y > 0.0:
			last_anim = "Abajo"
		else:
			last_anim = "Arriba"

	if anim.animation != last_anim or not anim.is_playing():
		anim.play(last_anim)

# Cuando el jugador entra o sale del área de la camioneta
func _on_van_area_body_entered(body):
	if body == self:
		near_van = true

func _on_van_area_body_exited(body):
	if body == self:
		near_van = false
		ui_label.visible = false
		waiting_for_confirm = false

# Efecto del viaje
func start_trip():
	ui_label.visible = false
	black_screen.visible = true
	black_screen.modulate.a = 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(black_screen, "modulate:a", 1.0, 1.5)
	await tween.finished

	ui_label.text = "Después de una semana..."
	ui_label.visible = true
	await get_tree().create_timer(2.5).timeout

	ui_label.visible = false
	tween = get_tree().create_tween()
	tween.tween_property(black_screen, "modulate:a", 0.0, 1.5)
	await tween.finished
	black_screen.visible = false

	change_farm_state()

func change_farm_state():
	print("🔄 Algo cambió en la granja.")
