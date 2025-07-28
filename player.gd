extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

@export var upGrav := 10.0;
@export var downGrav := 20.0;



@export var animTree : AnimationTree;
var animState : AnimationNodeStateMachinePlayback;

@export var playerGFX : Sprite2D;

var was_on_floor := true;

func _ready():
	animState = animTree.get("parameters/playback");


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y += upGrav * delta;
		else:
			velocity.y += downGrav * delta;
	

	# transition from falling to grounded anim
	# print(!was_on_floor, is_on_floor());





	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED

		if is_on_floor():
			animState.travel("run");

		if direction > 0:
			playerGFX.flip_h = false;
		else:
			playerGFX.flip_h = true;

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

		if is_on_floor():
			animState.travel("idle");
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animState.travel("jump_start");

	move_and_slide()


	if !was_on_floor && is_on_floor():
		print("transition to ground")

		animState.travel("landing");
	
	was_on_floor = is_on_floor();
