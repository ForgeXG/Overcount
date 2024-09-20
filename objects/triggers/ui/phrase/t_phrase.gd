extends Area2D

@export var open : bool = true
@export var s_group : int = -1
@export_multiline var text : String = ""
@export var char_ind : int = 0
var player : Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	modulate.a = 0.5

func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Player") and open:
		activate()

func activate():
	player.dialogue.phrases.append(player.Phrase.create_phrase(text, char_ind))
	if player.dialogue.phrase_ind < player.dialogue.phrases.size() - 1:
		player.dialogue.phrase_ind += 1
		player.get_node("PlayerUI/DialogueBox/TextDialogue").visible_ratio = 0
	open = false
	modulate.a = 0
