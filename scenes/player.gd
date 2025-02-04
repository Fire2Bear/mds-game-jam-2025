extends CharacterBody2D


var speed = 300
var jumpSpeed = -500
var canJump
var maxAuthorizedFallSpeed = 1400
var minimumFallSpeedToDisplayFire = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_pressed("jump"):
		velocity.y = jumpSpeed

	# Get the input direction.
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	if velocity.x != 0:
		$AnimatedSprite2D.play("walking")
	else:
		$AnimatedSprite2D.play("standing")
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true

	move_and_slide()
	
	if $RayCast2D.is_colliding() and velocity.y > maxAuthorizedFallSpeed:
		var colliding = $RayCast2D.get_collider()
		if colliding.is_in_group("platform"):
			colliding.makeAHole(position.x)

func _process(delta):
	updateFireShader()
	$ArmContainer.look_at(get_global_mouse_position())

func updateFireShader():
	var percentageAuthorizedFallSpeed = clamp(velocity.y / maxAuthorizedFallSpeed , 0, 1) * 0.8
	var gradient_data := {
		0: Color.WHITE,
		percentageAuthorizedFallSpeed: Color.BLACK,
	}
	var gradient := Gradient.new()
	gradient.offsets = gradient_data.keys()
	gradient.colors = gradient_data.values()

	var gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient
	$FireEffect.material.set("shader_parameter/texture_add", gradient_texture)
	
	$FireEffect.visible = velocity.y > minimumFallSpeedToDisplayFire
