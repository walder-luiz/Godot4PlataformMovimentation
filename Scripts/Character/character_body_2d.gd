extends CharacterBody2D


var GRAVITY : float = 10.0

var ImpulseY : float = 1.0
var ImpulseX : float = 0.0

var Velocity : float = 3.0

@export var VelX : float = 2.5


#Directional Moviments-------------------------------------

var Right : bool = false
var Left : bool = false
var Down : bool = false
var Up : bool = false

var DirectionX : int = 1
#Directional Moviments--------------------------------------

#Actions Moviments--------------------------------------------

#Simple Jump--------------------------------------------------
var Jump : bool = false
var JumpPressed : bool = false
var AmouthMaxJumps : int = 1
var MaxJumps : int = 1
var TimeInterruptJump : float = 0
#Simple Jump--------------------------------------------------

#Deafault Dash------------------------------------------------

var Dash : bool = false
var TimeDash : float = 0.0
var LimitTimeDash : float = 0.6
var VelDash : float = 8.0
var ImpulseDash : float = 0.0

#Deafault Dash------------------------------------------------

#Atack And Deff-----------------------------------------------

var Atack : bool = false
var Deff : bool = false

#Atack And Deff-----------------------------------------------

#WallJump------------------------------------------------------------------------

var RightWallJump : bool = false
var RightWallJumpPressed : bool = false

var LeftWallJump : bool = false
var LeftWallJumpPressed : bool = false

var IntervalTimeWallJump : float = 0.2
var TimeWallJump : float = 0.0

var TimeDashWallJump : float = 0.0
var IntervalDashWallJump : float = 0.2

#WallJump------------------------------------------------------------------------

#Actions Moviments------------------------------------------------------------


func _ready():
	
	pass


func _physics_process(delta):
	
	Movimentation(delta)
	Buttons(delta)
	
	pass


func Buttons(delta):
	
	Right = Input.is_action_pressed("Right") and TimeDash == 0
	Left = Input.is_action_pressed("Left") and TimeDash == 0
	Up = Input.is_action_pressed("Up") and TimeDash == 0
	Down = Input.is_action_pressed("Down") and TimeDash == 0
	
	# O jump nao é just pressed para que quanto mais tempo o
	#botão de pulo seja pressionado maior seja o pulo.
	Jump = Input.is_action_pressed("Jump")
	
	Dash = Input.is_action_just_pressed("Dash")
	
	pass


func Movimentation(delta):
	
	move_and_slide()
	
	if Right:
		
		
		
		ImpulseX += delta * 5
		
		if ImpulseX > 1:
			ImpulseX = 1
		
		DirectionX = 1
		
	
	move_local_x(ImpulseX * Velocity)
	
	
	_Directional(delta)
	_Jump(delta)
	_WallJump(delta)
	_Dash(delta)
	
	move_local_y(GRAVITY * ImpulseY)
	
	move_local_x((ImpulseX * Velocity) + (VelDash * ImpulseDash))
	
	pass

func _Jump(delta):
	
	ImpulseY += delta * 4
	
	if ImpulseY > 1:
		ImpulseY = 1
	
	if is_on_floor():
		ImpulseY = 0
	
	if is_on_floor() and !Jump:
		
		TimeInterruptJump = 0
		MaxJumps = AmouthMaxJumps
		
	
	if !Jump:
		JumpPressed = false
	
	if Jump and is_on_floor() and JumpPressed == false:
		JumpPressed = true
		if MaxJumps > 0:
			
			MaxJumps -= 1
			
			
			if TimeDash == 0:
				ImpulseY = - 1.5
			if TimeDash != 0:
				ImpulseY = - 1.7
	
	
	if !Jump and ImpulseY < 0:
		ImpulseY = 0.0
		
	pass

func _Directional(delta):
	
	if Left:
		
		
		
		ImpulseX -= delta * 5
		
		if ImpulseX < -1:
			ImpulseX = -1
		
		DirectionX = -1
		
	
	if !Right and !Left:
		if ImpulseX > 0:
			ImpulseX -= delta * 4
		if ImpulseX < 0:
			ImpulseX += delta * 4
		
		if ImpulseX > -0.2 and ImpulseX < 0.2:
			ImpulseX = 0
	
	pass

func _Dash(delta):
	
	
	# O dash comum só poderá ser dado no chão, a velocidade
	#do dash será mantida durante o intervalo de tempo do
	#dash a menos que o personagem esteja pulando por exemplo.
	
	if (Dash and is_on_floor()) or (TimeDash > 0):
		TimeDash += delta
		ImpulseDash = DirectionX
	
	# A variável LimitTimeDash determina o tempo máximo 
	#do dash, nesse intervalo de tempo o impulso do dash
	#será mantido ao menos que o personagem mude de direção.
	#Em quanto o personagem estiver pulando e não tocar o chão
	#a velocidade do dash se manterá em ImpulseDash.
	
	if TimeDash > LimitTimeDash and is_on_floor() :
		TimeDash = 0
		ImpulseDash = 0
	
	if TimeDash > 0 and DirectionX == 1 and Input.is_action_just_pressed("Left"):
		TimeDash = 0
		ImpulseDash = 0
	
	if TimeDash > 0 and DirectionX == -1 and Input.is_action_just_pressed("Right"):
		TimeDash = 0
		ImpulseDash = 0
	
	
	
	pass

func _WallJump(delta):
	
	#RightWallJump----------------------------------------------------------
	
	if RightWallJumpPressed and RightWallJump and !Jump:
		RightWallJumpPressed = false
	
	
	if RightWallJump and Right:
		GRAVITY = 4
	
	
	if RightWallJump and Jump and TimeDash == 0 and !JumpPressed and !RightWallJumpPressed and TimeWallJump > 0:
		RightWallJumpPressed = true
		LeftWallJumpPressed = true
		JumpPressed = true
		
		if TimeDashWallJump == 0:
			ImpulseX = -0.7
			ImpulseY = -1.7
			GRAVITY = 10.0
		if TimeWallJump > 0:
			ImpulseX = -1.0
			ImpulseY = -1.85
			GRAVITY = 10.0
	
	if Right and RightWallJump:
		TimeWallJump = IntervalTimeWallJump
	
	if !Right and RightWallJump:
		if TimeWallJump > 0:
			TimeWallJump -= delta
		if TimeWallJump <= 0:
			ImpulseX = -0.3
			RightWallJump = false
	
	if !LeftWallJump and !RightWallJump:
		
		GRAVITY = 10.0
	
	#RightWallJump----------------------------------------------------------
	
	#LeftWallJump----------------------------------------------------------
	
	if LeftWallJumpPressed and LeftWallJump and !Jump:
		LeftWallJumpPressed = false
	
	
	if LeftWallJump and Left:
		GRAVITY = 4
		
	
	if LeftWallJump and Jump and TimeDash == 0 and !JumpPressed and !LeftWallJumpPressed and TimeWallJump > 0:
		RightWallJumpPressed = true
		LeftWallJumpPressed = true
		JumpPressed = true
		
		if TimeDashWallJump == 0:
			ImpulseX = 0.7
			ImpulseY = -1.7
			GRAVITY = 10.0
		if TimeDashWallJump > 0:
			ImpulseX = 1.0
			ImpulseY = -2
			GRAVITY = 10.0
			
	
	
	if Left and LeftWallJump:
		TimeWallJump = IntervalTimeWallJump
	
	if !Left and LeftWallJump:
		if TimeWallJump > 0:
			TimeWallJump -= delta
		if TimeWallJump <= 0:
			ImpulseX = 0.3
			RightWallJump = false
	
	
	if !Left and LeftWallJump and TimeWallJump == 0:
		ImpulseX = 0.3
		LeftWallJump = false
		RightWallJump = false
	
	if !LeftWallJump and !RightWallJump:
		
		GRAVITY = 10.0
	
	#LeftWallJump----------------------------------------------------------
	
	#Dash Witch Wall Jump----------------------------------------
	
	'''
	Cria um tipo de cronõmetro que diminuirá sempre
	que a variável TimeDashWallJump for maior que zero
	a partir do momento que Dash forpressionado durante
	o wall jump. Isso permitirá um pulo mais alto e com
	mais velocidade caso o jogador aperte Dash e pule em
	um intervalo de tempo muito curto após aperter o Dash.
	'''
	
	#Faz o TimeDashWallJump ficar com o valor maior que zero
	#no caso o valor do IntervalDashWallJump caso o dash seja
	#pressionado durante o wall jump.
	
	if RightWallJump or LeftWallJump:
		if Dash:
			TimeDashWallJump = IntervalDashWallJump
	
	
	#Faz o TimeDashWallJump diminuir caso ele seja mair que 
	#zero.
	if TimeDashWallJump > 0:
		TimeDashWallJump -= delta
	
	#Faz com que  o tempo de dash com wall jump fique igual 
	#a zero caso ela fique menor que zero.
	
	if TimeDashWallJump < 0:
		TimeDashWallJump = 0
	
	
	#Dash Witch Wall Jump----------------------------------------
	
	pass

func _on_right_wall_jump_body_entered(body):
	
	if body.name != name and body.has_node("Wall"):
		RightWallJump = true
		TimeWallJump = IntervalTimeWallJump
		TimeDash = 0.0
		ImpulseDash = 0
	pass # Replace with function body.


func _on_right_wall_jump_body_exited(body):
	
	if body.name != name and body.has_node("Wall"):
		RightWallJump = false
		JumpPressed = false
		TimeWallJump = false
		
	pass # Replace with function body.


func _on_left_wall_jump_body_entered(body):
	
	if body.name != name and body.has_node("Wall"):
		LeftWallJump = true
		TimeWallJump = IntervalTimeWallJump
		TimeDash = 0.0
		ImpulseDash = 0
	
	pass # Replace with function body.


func _on_left_wall_jump_body_exited(body):
	
	if body.name != name and body.has_node("Wall"):
		LeftWallJump = false
		JumpPressed = false
		TimeWallJump = 0
		
	
	pass # Replace with function body.
