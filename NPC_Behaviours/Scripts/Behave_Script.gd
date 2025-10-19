extends Node
class_name BaseBehaviour_Component

@export_group('Settings')
@export var node_Name : String = self.name

signal state_Terminated

func _on_enter() -> void:
	pass

func _on_process(delta : float) -> void:
	pass

func _on_exit() -> void:
	pass
