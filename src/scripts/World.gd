extends Spatial

onready var camera = $Scenography/Camera

onready var depressed = $Navigation/Depressed
onready var navigation = $Navigation
onready var robot = $Navigation/Robot
onready var area_hotel_spots: Array = Array($Navigation/AreaHotel/Spots.get_children())

"""
To make AI living their life, we define some spots in a area. Then we take 1 spot randomly
and make an AI going there. Then it will stay there for a time, and then it will move to another
spot
"""
func _ready():
    depressed.navigation = navigation
    depressed.set_target(area_hotel_spots[0])
