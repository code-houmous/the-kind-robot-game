extends Spatial

onready var depressed = $Navigation/Depressed
onready var navigation = $Navigation
onready var robot = $Navigation/Robot

func _ready():
    depressed.navigation = navigation
    depressed.target = robot
