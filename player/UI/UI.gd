extends Control

onready var health_bar = $HL/VL/scaler/HEALTHBAR
onready var dash_bar = $HL/VL/scaler/DASHBAR
onready var score_txt = $HL/VL/score
onready var player = get_parent().get_parent()


export var health = 10
export var max_health = 10

export var dash = 3
export var max_dash = 3

export var score = 0

func _ready():
	pass

func _process(delta):
	health_bar.value = health
	health_bar.max_value = max_health
	dash_bar.value = dash
	dash_bar.max_value = max_dash
	score_txt.text = "Score: " + str(score)
