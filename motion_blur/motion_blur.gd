extends MeshInstance


export var _camera_controller_path: NodePath
export var blur_factor := 1.5

var cam_rot_prev: Quat

onready var camera_controller := get_node(_camera_controller_path)


func _process(delta):
	
	var mat = get_surface_material(0)
	var cam = get_parent()
	assert(cam is Camera)
	
	# Angular velocity is a little more complicated, as you can see.
	# See https://math.stackexchange.com/questions/160908/how-to-get-angular-velocity-from-difference-orientation-quaternion-and-time
	var cam_rot = Quat(cam.global_transform.basis)
	var cam_rot_diff = cam_rot - cam_rot_prev
	var cam_rot_conj = conjugate(cam_rot)
	var ang_vel = (cam_rot_diff * 2.0) * cam_rot_conj; 
	ang_vel = Vector3(ang_vel.x, ang_vel.y, ang_vel.z) # Convert Quat to Vector3
	
	mat.set_shader_param("linear_velocity", camera_controller.linear_velocity * delta * blur_factor)
	mat.set_shader_param("angular_velocity", ang_vel * blur_factor)
		
	cam_rot_prev = Quat(cam.global_transform.basis)


# Calculate the conjugate of a quaternion.
func conjugate(quat):
	return Quat(-quat.x, -quat.y, -quat.z, quat.w)
