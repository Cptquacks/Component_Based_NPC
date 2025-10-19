extends BaseBehaviour_Component
class_name PatrolBehaviour_Component

@export_group('Settings')
@export var wait_Until : float = 0.0
@export var navigation_Repeat : bool = true

@export_group('Components')
@export var parent_Node : NPCharacter_Prefab = null

@export var navigation_Agent : NavigationAgent2D = null
@export var navigation_Points : Array[Marker2D] = []
@export var navigation_Target : Marker2D = null


func _on_enter() -> void:
	if !navigation_Agent.velocity_computed.is_connected(_on_velocity_computed) : navigation_Agent.velocity_computed.connect(_on_velocity_computed)
	if !navigation_Agent.target_reached.is_connected(_on_target_reached) : navigation_Agent.target_reached.connect(_on_target_reached)
	
	navigation_Target = navigation_Points[0]
	navigation_Agent.target_position = navigation_Target.position

func _on_process(delta : float) -> void:
	navigation_Agent.set_velocity(
		(_get_target() * parent_Node.mov_Speed) * delta
	)

func _next_target() -> void:
	if navigation_Points.find(navigation_Target) < navigation_Points.size() - 1:
		navigation_Target = navigation_Points[navigation_Points.find(navigation_Target) + 1]
	
	elif navigation_Points.find(navigation_Target) == navigation_Points.size() - 1 && navigation_Repeat:
		navigation_Target = navigation_Points[0]
	
	elif navigation_Points.find(navigation_Target) == navigation_Points.size() - 1 && !navigation_Repeat:
		state_Terminated.emit()

	navigation_Agent.target_reached.connect(_on_target_reached)

func _get_target() -> Vector2:
	navigation_Agent.target_position = navigation_Target.position
	return parent_Node.global_position.direction_to(navigation_Agent.get_next_path_position())

func _on_velocity_computed(safe_velocity : Vector2) -> void:
	parent_Node.velocity = parent_Node.velocity.lerp(
		safe_velocity * parent_Node.mov_Multiplier,
		parent_Node.mov_Smoothing
	)
	parent_Node.move_and_slide()

func _on_target_reached() -> void:
	navigation_Agent.target_reached.disconnect(_on_target_reached)
	if wait_Until > 0:
		await get_tree().create_timer(wait_Until).timeout
	
	_next_target()
	
