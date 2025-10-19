extends CharacterBody2D
class_name NPCharacter_Prefab

@export_group('Settings')
@export var Name : String = self.name
@export var mov_Speed : float = 75.0
@export var mov_Multiplier : float = 100.0
@export_exp_easing('attenuation') var mov_Smoothing : float = 0.5

@export_group('Components')
@export var AI_Behaviour : Array[BaseBehaviour_Component] = []
@export var current_Behaviour : int = 0

@export var navigation_Agent : NavigationAgent2D = null
@export var animation_Controller : AnimationTree = null

func _ready() -> void:
	if AI_Behaviour.is_empty() : return
	AI_Behaviour[current_Behaviour].state_Terminated.connect(_switch_behaviours)
	AI_Behaviour[current_Behaviour]._on_enter()

func _process(delta: float) -> void:
	if !AI_Behaviour.is_empty() : AI_Behaviour[current_Behaviour]._on_process(delta)

func _switch_behaviours() -> void:
	AI_Behaviour[current_Behaviour]._on_exit()
	AI_Behaviour[current_Behaviour].state_Terminated.disconnect(_switch_behaviours)
	
	current_Behaviour += 1; print(current_Behaviour)
	
	if current_Behaviour >= AI_Behaviour.size():
		current_Behaviour = 0
		
	AI_Behaviour[current_Behaviour].state_Terminated.connect(_switch_behaviours)
	AI_Behaviour[current_Behaviour]._on_enter()
