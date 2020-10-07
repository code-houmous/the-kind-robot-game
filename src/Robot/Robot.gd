extends "../Parents/Body.gd"

var acceleration: float = 0.0

func _physics_process(delta):
    var direction: Vector3 = Vector3(0, 0, 0)

    if Input.is_action_pressed("ui_left"):
        direction.x -= 1
        orientation.x = direction.x
        orientation.z = direction.z
    if Input.is_action_pressed("ui_right"):
        direction.x += 1
        orientation.x = direction.x
        orientation.z = direction.z
    if Input.is_action_pressed("ui_up"):
        direction.z -= 1
        orientation.z = direction.z
        orientation.x = direction.x
    if Input.is_action_pressed("ui_down"):
        direction.z += 1
        orientation.z = direction.z
        orientation.x = direction.x

    direction = direction.normalized()

    acceleration = accelerate(direction, acceleration)

    velocity = orientation * acceleration * speed * delta

    velocity = gravity(velocity, weight)

    animate(velocity, orientation)

    move_and_slide(velocity, Vector3.UP)

"""
Animates the sprite
"""
func animate(linear_velocity: Vector3, orientation: Vector3):
    if (linear_velocity.z < 0):
        $Sprites/Animation.play("walk_back")
        return
    if (linear_velocity.z > 0):
        $Sprites/Animation.play("walk_front")
        return
    if (linear_velocity.x < 0):
        $Sprites/Animation.play("walk_left")
        return
    if (linear_velocity.x > 0):
        $Sprites/Animation.play("walk_right")
        return

    # no movement : idle animation
    if (orientation.z < 0):
        $Sprites/Animation.play("idle_back")
        return
    if (orientation.z > 0):
        $Sprites/Animation.play("idle_front")
        return
    if (orientation.x == -1):
        $Sprites/Animation.play("idle_left")
        return
    if (orientation.x == 1):
        $Sprites/Animation.play("idle_right")
        return

    $Sprites/Animation.play("idle_front")

func accelerate(direction: Vector3, coefficient: float) -> float:
    if (direction.x != 0 or direction.z != 0):
        coefficient += 0.05

        return min(coefficient, 1.0)

    coefficient -= 0.05

    return max(0.0, coefficient)
