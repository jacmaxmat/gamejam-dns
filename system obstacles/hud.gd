extends HBoxContainer

@export var heart1: TextureRect
@export var heart2: TextureRect
@export var heart3: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.hud = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_health(amount):
	match amount:
		2:
			heart3.visible = false
		1:
			heart3.visible = false
			heart2.visible = false
		0:
			heart3.visible = false
			heart2.visible = false
			heart1.visible = false

func update_score(amount):
	$Score.text = "Score: " + str(Global.score)
