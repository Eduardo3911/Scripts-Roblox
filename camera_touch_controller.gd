extends Camera3D

# Configurações exportadas para ajustar no editor
@export var touch_sensitivity: float = 0.003
@export var min_vertical_angle: float = -80.0
@export var max_vertical_angle: float = 80.0
@export var smooth_rotation: bool = true
@export var rotation_speed: float = 10.0

# Variáveis de controle
var is_touching: bool = false
var touch_start_position: Vector2
var current_rotation: Vector2
var target_rotation: Vector2

func _ready():
	# Inicializa as rotações atuais
	current_rotation = Vector2(rotation_degrees.x, rotation_degrees.y)
	target_rotation = current_rotation
	
	# Garante que os inputs de toque sejam processados
	set_process_unhandled_input(true)

func _process(delta):
	# Aplicação suave da rotação (se habilitada)
	if smooth_rotation:
		current_rotation = current_rotation.lerp(target_rotation, rotation_speed * delta)
		rotation_degrees.x = current_rotation.x
		rotation_degrees.y = current_rotation.y
	else:
		rotation_degrees.x = target_rotation.x
		rotation_degrees.y = target_rotation.y

func _unhandled_input(event):
	# Processa apenas eventos de toque para celular
	if event is InputEventScreenTouch:
		handle_touch_event(event)
	elif event is InputEventScreenDrag:
		handle_drag_event(event)

func handle_touch_event(event: InputEventScreenTouch):
	if event.pressed:
		# Início do toque
		is_touching = true
		touch_start_position = event.position
	else:
		# Fim do toque
		is_touching = false

func handle_drag_event(event: InputEventScreenDrag):
	if not is_touching:
		return
	
	# Calcula o movimento do toque
	var touch_delta = event.relative
	
	# Converte o movimento em rotação
	var rotation_delta = Vector2(
		-touch_delta.y * touch_sensitivity * 180.0,  # Rotação vertical (pitch)
		-touch_delta.x * touch_sensitivity * 180.0   # Rotação horizontal (yaw)
	)
	
	# Aplica a rotação
	target_rotation += rotation_delta
	
	# Limita a rotação vertical
	target_rotation.x = clamp(target_rotation.x, min_vertical_angle, max_vertical_angle)
	
	# Normaliza a rotação horizontal (evita overflow)
	target_rotation.y = fmod(target_rotation.y, 360.0)