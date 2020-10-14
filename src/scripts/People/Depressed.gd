extends "res://src/scripts/Parents/AI.gd"

func _ready():
    speed = 10

func _physics_process(delta):
    animate(velocity, orientation)

"""
Animates the sprite
"""
func animate(linear_velocity: Vector3, orientation: Vector3):
    if (linear_velocity.x < 0):
        $Animation.play("walk_left")
        return
    if (linear_velocity.x > 0):
        $Animation.play("walk_right")
        return
    if (linear_velocity.z < 0):
        $Animation.play("walk_left")
        return
    if (linear_velocity.z > 0):
        $Animation.play("walk_right")
        return

    # no movement : idle animation
    if (orientation.x < 0):
        $Animation.play("idle_left")
        return
    if (orientation.x >= 0):
        $Animation.play("idle_right")
        return
    if (orientation.z < 0):
        $Animation.play("idle_left")
        return
    if (orientation.z >= 0):
        $Animation.play("idle_right")
        return

    $Animation.play("idle_left")