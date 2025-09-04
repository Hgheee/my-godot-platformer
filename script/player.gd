extends CharacterBody2D

@export var speed: float = 166
@export var jump_force: float = -300
@export var gravity: float = 888
@export var fall_multiplier: float = 1.7 # 빠른 낙하 배율
@export var jump_cut_multiplier: float = 3.5 # 점프 버튼 떼면 더 빨리 떨어지는 배율
@export var low_gravity_multiplier: float = 0.8 # 점프 버튼 유지시 중력 약화

@onready var animatedsprite = $AnimatedSprite2D

func _physics_process(delta): 
	#중력적용
	if not is_on_floor():
		# 기본 중력
		var current_gravity = gravity
		# 빠른 낙하
		if Input.is_action_pressed("ui_down"):
			current_gravity *=fall_multiplier
		# 점프 키를 뗀 경우 빨리 떨어짐
		elif not Input.is_action_pressed("ui_accept") and velocity.y < 0:
			current_gravity *= jump_cut_multiplier
		# 점프 키 유지 중 -> 위로 뜰 때만 중력 약화(높은 점프)
		elif Input.is_action_pressed("ui_accept") and velocity.y < 0:
			current_gravity *= low_gravity_multiplier

		velocity.y += current_gravity * delta
	#좌우이동
	var input_dir = Input.get_axis("ui_left", "ui_right")
	velocity.x = input_dir * speed
	
	#점프
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
	
	#---애니메이션 처리---
	if velocity.x !=0:
		if animatedsprite.animation !="run":
			animatedsprite.play("run")
	else:
		if animatedsprite.animation !="idle":
			animatedsprite.play("idle")
	#---좌우 반전---
	if velocity.x < 0:
		animatedsprite.flip_h = true
	elif velocity.x > 0:
		animatedsprite.flip_h = false
	move_and_slide()
