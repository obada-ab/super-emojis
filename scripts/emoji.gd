class_name Emoji

extends Node2D

@export var health: int = 15
@export var attack: int = 5
@export var press_turn: bool = false
var attackText: RichTextLabel
var healthText: RichTextLabel

func _ready():
	attackText = get_node("Attack")
	healthText = get_node("Health")


func _process(delta):
	attackText.text = "⚔" + str(attack)
	healthText.text = "❤️" + str(health)
