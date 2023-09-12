@tool
extends Camera2D

@export var max_zoom: float = 3
@export var camera_factor: Vector2 = Vector2.ONE
@export var zoom_padding: Vector2 = Vector2.ONE * 32
@export var solo_zoom: int = 3
@export_enum("Normal", "Stage", "Zoom") var mode: int = 0
@export var targets_paths: Array[NodePath]
@export var CameraShape: CollisionShape2D
@export_enum("None", "Editor", "Game", "Both") var debug_mode: int = 0

@onready var viewport_size: Vector2 = get_viewport_rect().size
@onready var CameraZone: Vector2 = viewport_size
@onready var ratio: Vector2 = viewport_size / CameraZone
@onready var min_zoom: float = min(ratio.x, ratio.y)

var avg: Vector2
var longest_dist: Vector2
var targets: Array
var min_pos: Vector2
var max_pos: Vector2
var debug: bool

func _ready():
	if CameraShape:
		CameraZone = CameraShape.shape.size
	CameraZone *= camera_factor

func move():
	avg *= 0
	if mode != 2:
		avg = (clamp_pos(min_pos) + clamp_pos(max_pos)) / 2
	else:
		avg = clamp_pos(targets[0].global_position)
	offset = avg.clamp((-CameraZone / 2 + viewport_size / zoom / 2), (CameraZone / 2 - viewport_size / zoom / 2))

func zooming():
	longest_dist *= 0
	var distance: Vector2
	distance = abs(clamp_pos(min_pos - zoom_padding) - clamp_pos(max_pos + zoom_padding))
	longest_dist.x = max(longest_dist.x, distance.x)
	longest_dist.y = max(longest_dist.y, distance.y)
	if targets.size() > 1 and mode == 0:
		zoom = viewport_size / longest_dist
		zoom = Vector2.ONE * min(zoom.x, zoom.y)
	else:
		zoom = solo_zoom * Vector2.ONE
	zoom = zoom.clamp(Vector2.ONE * min_zoom, Vector2.ONE * max_zoom)
 
func _physics_process(delta):
	debug = debug_mode == 3 or debug_mode == 2 and not Engine.is_editor_hint() or debug_mode == 1 and Engine.is_editor_hint()
	targets = (targets_paths.filter(func f(x: NodePath) -> bool: return get_node_or_null(x) != null).map(func f(x: NodePath) -> Node: return get_node(x))) as Array[Node]
	CameraZone = (CameraShape.shape.size if CameraShape else viewport_size) * camera_factor
	if targets.size() and mode != 1:
		min_pos = targets[0].global_position
		max_pos = targets[0].global_position
		for target in targets:
			set_extrems(target.global_position)
		zooming()
		move()
	else:
		offset *= 0
		zoom = Vector2.ONE * min_zoom
	if debug:
		queue_redraw()

func clamp_pos(pos: Vector2) -> Vector2:
	return pos.clamp(-CameraZone / 2, CameraZone / 2)

func set_extrems(pos: Vector2) -> void:
	min_pos.x = min(min_pos.x, pos.x)
	min_pos.y = min(min_pos.y, pos.y)
	max_pos.x = max(max_pos.x, pos.x)
	max_pos.y = max(max_pos.y, pos.y)

func _draw():
	if debug:
		draw_rect(Rect2(-CameraZone / 2 + global_position, CameraZone), Color(Color.WHITE, 0.2), true)
		draw_rect(Rect2(-viewport_size / zoom / 2 + offset, viewport_size / zoom), Color(Color.PURPLE, 0.2), true)
		draw_circle(Vector2(-viewport_size.x / zoom.x / 2 + offset.x, offset.y), 20 / zoom.x, Color.RED)
		draw_circle(Vector2(viewport_size.x / zoom.x / 2 + offset.x, offset.y), 20 / zoom.x, Color.RED)
		draw_circle(Vector2(offset.x, -viewport_size.y / zoom.y / 2 + offset.y), 20 / zoom.x, Color.RED)
		draw_circle(Vector2(offset.x, viewport_size.y / zoom.y / 2 + offset.y), 20 / zoom.x, Color.RED)
		var a: Vector2
		for i in targets:
			for j in targets:
				if i == j:
					continue
				draw_line(i.global_position, j.global_position, Color.WHITE, 3 / zoom.x)
			a += i.global_position
		a /= targets.size()
		draw_circle(a, 20 / zoom.x, Color.CYAN)
		draw_circle(offset, 20 / zoom.x, Color.GREEN)
		draw_circle(avg, 20 / zoom.x, Color.ORANGE)
		draw_circle(min_pos, 20 / zoom.x, Color.YELLOW)
		draw_circle(max_pos, 20 / zoom.x, Color.BLACK)
