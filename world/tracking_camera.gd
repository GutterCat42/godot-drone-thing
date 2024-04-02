extends Camera3D


var drone


func _ready():
	drone = get_parent().get_node("Drone")


func _process(delta):
	look_at(drone.global_position)
