extends Control


@onready var drone = get_parent().get_parent()


func _process(delta):
	$Crosshair.rotation = drone.rotation.z
	$Crosshair/Sprite2D.rotation = -drone.rotation.z
	$Crosshair/PitchLadder.position.y = $Crosshair.position.y - get_viewport_rect().size.y / 2 + (tan(drone.rotation.x) / tan(deg_to_rad(drone.get_node("MeshInstance3D4/Camera3D").fov) / 2) * get_viewport_rect().size.y / 2)
	
	$AirspeedLabel.text = str(round(drone.linear_velocity.z))
	$AltitudeLabel.text = str(round(drone.global_position.y))
	$VSILabel.text = str(round(drone.linear_velocity.y))
	
	$PitchLabel.text = str(round(drone.rotation_degrees.x))
	
	#$VelocityVector.position = drone.get_node("MeshInstance3D4/Camera3D").unproject_position(drone.to_global(drone.linear_velocity))


# altitude (ft/m?)
# vertical speed indicatior (vsi) (ft/m or m/m?)
# heading tape
# pitch ladder (downticks on outward side point towards horizon and degrees marking. negative dotted)
# airspeed (knots?)
# gs?
# velocity vector (path marker)
# roll indicator (bank indicator)
