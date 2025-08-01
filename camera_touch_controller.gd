extends Camera3D

# Sensibilidade da rotação
@export var sensitivity: float = 0.5
@export var max_vertical_angle: float = 80.0

# Variáveis para controle de toque
var is_touching: bool = false
var last_touch_position: Vector2
var rotation_x: float = 0.0
var rotation_y: float = 0.0

func _ready():
	# Configura a câmera
	rotation_x = rotation_degrees.x
	rotation_y = rotation_degrees.y

func _input(event):
	# Detecta eventos de toque
	if event is InputEventScreenTouch:
		if event.pressed:
			# Início do toque
			is_touching = true
			last_touch_position = event.position
		else:
			# Fim do toque
			is_touching = false
	
	elif event is InputEventScreenDrag and is_touching:
		# Movimento do dedo na tela
		var delta_touch = event.position - last_touch_position
		last_touch_position = event.position
		
		# Aplica a rotação baseada no movimento do toque
		rotation_y -= delta_touch.x * sensitivity
		rotation_x -= delta_touch.y * sensitivity
		
		# Limita a rotação vertical para evitar que a câmera vire de cabeça para baixo
		rotation_x = clamp(rotation_x, -max_vertical_angle, max_vertical_angle)
		
		# Aplica as rotações à câmera
		rotation_degrees.x = rotation_x
		rotation_degrees.y = rotation_y

func _unhandled_input(event):
	# Alternativa para mouse (para testes no editor)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_touching = true
				last_touch_position = event.position
			else:
				is_touching = false
	
	elif event is InputEventMouseMotion and is_touching:
		var delta_mouse = event.position - last_touch_position
		last_touch_position = event.position
		
		rotation_y -= delta_mouse.x * sensitivity
		rotation_x -= delta_mouse.y * sensitivity
		rotation_x = clamp(rotation_x, -max_vertical_angle, max_vertical_angle)
		
		rotation_degrees.x = rotation_x
		rotation_degrees.y = rotation_y