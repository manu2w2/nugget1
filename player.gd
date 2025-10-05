extends CharacterBody2D

# Velocidad del personaje (puedes cambiarla para que camine más rápido o más lento)
@export var speed: float = 200.0

# Conectamos el nodo AnimatedSprite2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# Guarda la última animación usada (para saber hacia dónde está mirando cuando se detiene)
var last_anim: String = "Abajo" # Usa el nombre exacto de tu animación hacia abajo

func _physics_process(_delta: float) -> void:
	# Lee la dirección de movimiento según las teclas (WASD)
	# Estas teclas deben estar configuradas en Project Settings → Input Map
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Aplica la velocidad al movimiento
	velocity = dir * speed

	# Mueve al personaje y maneja las colisiones automáticamente
	move_and_slide()

	# Actualiza la animación según la dirección
	_animate(dir)


func _animate(dir: Vector2) -> void:
	# Si no se está moviendo, mostrar el cuadro central de la última animación
	if dir == Vector2.ZERO:
		anim.stop()
		anim.animation = last_anim
		anim.frame = 1  # cuadro central
		return

	# Si se mueve, determinar hacia dónde y reproducir la animación correcta
	if abs(dir.x) > abs(dir.y):
		# Movimiento horizontal
		if dir.x > 0.0:
			last_anim = "Derecha"
		else:
			last_anim = "Izquierda"
	else:
		# Movimiento vertical
		if dir.y > 0.0:
			last_anim = "Abajo"
		else:
			last_anim = "Arriba"

	# Si la animación actual no coincide con la dirección, cámbiala
	if anim.animation != last_anim or not anim.is_playing():
		anim.play(last_anim)