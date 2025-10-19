extends BaseBehaviour_Component
class_name FollowPathBehaviour_Component

@export_group('Settings')
@export_exp_easing('attenuation') var mov_Smoothing : float = 0.5

@export_group('Components')
@export var parent_Node : NPCharacter_Prefab = null
@export var follow_Node : PathFollow2D = null
@export var target_Path : Path2D = null

func _on_enter() -> void:
	if parent_Node == null : parent_Node = get_parent()
	follow_Node.progress_ratio = 0

func _on_process(delta : float) -> void:
	follow_Node.progress_ratio += 0.1 * delta
	parent_Node.position = lerp(follow_Node.position, follow_Node.position, mov_Smoothing)
	
	if follow_Node.progress_ratio >= 1 && parent_Node.position == follow_Node.position : state_Terminated.emit()

func _on_exit() -> void:
	pass
