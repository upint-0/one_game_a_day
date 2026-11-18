extends RigidBody3D

var player: Player = null

@onready var interactable_deck: Interactable = %Interactable_Deck


func _ready() -> void:
	interactable_deck.interacted_with_source.connect(_on_deck_interacted)


func _on_deck_interacted(interactor: Node3D) -> void:
	player = interactor.owner
	player.global_position = global_position + Vector3.UP
	player.linear_velocity = Vector3.ZERO
