extends "res://src/scripts/Parents/Body.gd"
class_name AI

"""
Provides a class to inherit from if you want an object to move alone
from its position to a target
"""

# current position
var position: Vector3 = Vector3(0, 0, 0)

# target to reach, end of the path
var target = null

# Navigation Node
var navigation: Navigation = null

# a series of vector that contains the path
var path: PoolVector3Array

# how close the AI should be to admit it reaches a point
var distance_min: float = 0.3

# did he reached his target ?
var has_reached_target: bool = false

func _physics_process(delta):
    if !target:
        return

    if path.size() == 0:
        return

    position = global_transform.origin

    var distance: float = position.distance_to(path[0])
    var direction: Vector3 = position.direction_to(path[0])

    # distance if far enough, we rotate the sprite in the good direction
    if (distance >= distance_min):
        orientation = calculate_orientation(direction)

    acceleration = accelerate(direction, acceleration)

    velocity = gravity(velocity, weight)

    # the AI reached a node in the path
    if (distance < distance_min and path.size() > 0):
        path.remove(0)

    # no vectors in the path means we reached the target
    if path.size() == 0:
        velocity.x = 0
        velocity.z = 0
        acceleration = 0
        has_reached_target = true

    velocity = direction * acceleration * speed * delta

    move_and_slide(velocity, Vector3.UP)

"""
Calculate a path from position to target
"""
func calculate_path(target) -> PoolVector3Array:
    return navigation.get_simple_path(global_transform.origin, target.global_transform.origin)

"""
Gives the orientation from the direction
"""
func calculate_orientation(direction: Vector3) -> Vector3:
    var out = Vector3(0, 0, 0)

    if (direction.x < 0):
        out.x = -1

    if (direction.x > 0):
        out.x = 1

    if (direction.z < 0):
        out.z = -1

    if (direction.z > 0):
        out.z = 1

    return out

"""
Sets the target
"""
func set_target(target: Spatial):
    has_reached_target = false
    self.target = target
    path = calculate_path(target)

    if path.size() == 0:
        return

    # first value is like the position of the AI itslef
    # so we remove it, otherwise it would stay where it is
    path.remove(0)