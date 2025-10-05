extends StaticBody2D

var jugador_cerca = false
var paso = 0
var ui_mensajes

func _ready():
	var area = $Area2D
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	area.connect("body_exited", Callable(self, "_on_body_exited"))
	ui_mensajes = get_tree().get_first_node_in_group("ui_mensajes")

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		jugador_cerca = true

func _on_body_exited(body):
	if body.is_in_group("jugador"):
		jugador_cerca = false
		paso = 0 # reinicia diálogo si se aleja

func _process(delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		if paso == 0:
			ui_mensajes.mostrar_mensaje("Te irás de viaje por una semana 🚙")
			paso = 1
		elif paso == 1:
			ui_mensajes.mostrar_mensaje("Presiona E otra vez para aceptar el viaje.")
			paso = 2
		elif paso == 2:
			iniciar_viaje()

func iniciar_viaje():
	ui_mensajes.mostrar_pantalla_negra("Después de una semana...")

