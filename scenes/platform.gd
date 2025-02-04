extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$OpeningSprite2D.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func makeAHole(xPosition):
	#hide()
	$CollisionPolygon2D.disabled = true
	$OpeningSprite2D.position.x = xPosition
	$OpeningSprite2D.position.y = position.y + 116
	$OpeningSprite2D.visible = true
