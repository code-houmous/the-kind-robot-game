extends KinematicBody

# wieght of the body, force that will be used to calculate gravity
var weight: float = 90

# orientation of the subject
var orientation: = Vector3(0, 0, 0)

# speed for moving
var speed: float = 60

# velocity
var velocity: Vector3 = Vector3(0, 0, 0)

"""
Returns the velocity with gravity added
"""
func gravity(linear_velocity: Vector3, force: float) -> Vector3:
    var out: Vector3 = linear_velocity;

    # limiting the calculation
    if out.y < -30000:
        out.y = -30000
        return out

    out.y -= force * get_physics_process_delta_time()

    return out
