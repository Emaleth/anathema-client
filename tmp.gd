extends Node

func interpolate_or_extrapolate():
	var render_time = Server.client_clock - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > float(world_state_buffer[2]["T"]):
			world_state_buffer.remove(0)
		if world_state_buffer.size() > 2:
			interpolate(render_time)
		elif render_time > float(world_state_buffer[1]["T"]):
			extrapolate(render_time)

func interpolate(_render_time):
	var interpolation_factor = float(_render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
	# PLAYERS
	for pc in world_state_buffer[2]["P"].keys():
		if not world_state_buffer[1]["P"].has(pc): # WE WANT TO BE SURE THAT BOTH WS1 AND WS2 HAVE ANY GIVEN KEY FOR INTERPOLATION'S SAKE
			continue
		if pc_collection.has(str(pc)):
			var modified_data := {}
			modified_data = world_state_buffer[2]["P"][pc].duplicate(true)
			modified_data["pos"] = lerp(world_state_buffer[1]["P"][pc]["pos"], world_state_buffer[2]["P"][pc]["pos"], interpolation_factor)
			var current_rot = (world_state_buffer[1]["P"][pc]["rot"]).get_rotation_quat()
			var target_rot = (world_state_buffer[2]["P"][pc]["rot"]).get_rotation_quat()
			modified_data["rot"] = Basis(current_rot.slerp(target_rot, interpolation_factor))
			update_pc_inside_the_collection(pc, modified_data)
		else:
			add_pc_to_the_collection(pc, world_state_buffer[2]["P"][pc])
	for pc in pc_collection:
		if not world_state_buffer[2]["P"].keys().has(pc):
			remove_pc_from_the_collection(pc)

	# ENEMIES
	for npc in world_state_buffer[2]["E"].keys():
		if not world_state_buffer[1]["E"].has(npc): # WE WANT TO BE SURE THAT BOTH WS1 AND WS2 HAVE ANY GIVEN KEY FOR INTERPOLATION'S SAKE
			continue
		if npc_collection.has(npc):
			var modified_data := {}
			modified_data = world_state_buffer[2]["E"][npc].duplicate(true)
			modified_data["pos"] = lerp(world_state_buffer[1]["E"][npc]["pos"], world_state_buffer[2]["E"][npc]["pos"], interpolation_factor)
			var current_rot = (world_state_buffer[1]["E"][npc]["rot"]).get_rotation_quat()
			var target_rot = (world_state_buffer[2]["E"][npc]["rot"]).get_rotation_quat()
			modified_data["rot"] = Basis(current_rot.slerp(target_rot, interpolation_factor))
			update_npc_inside_the_collection(npc, modified_data)
		else:
			add_npc_to_the_collection(npc, world_state_buffer[2]["E"][npc])
	for npc in npc_collection:
		if not world_state_buffer[2]["E"].keys().has(npc):
			remove_npc_from_the_collection(npc)

	# BULLET
	for bullet in world_state_buffer[2]["B"].keys():
		if not world_state_buffer[1]["B"].has(bullet): # WE WANT TO BE SURE THAT BOTH WS1 AND WS2 HAVE ANY GIVEN KEY FOR INTERPOLATION'S SAKE
			continue
		if bullet_collection.has(bullet):
			var modified_data := {}
			modified_data = world_state_buffer[2]["B"][bullet].duplicate(true)
			modified_data["pos"] = lerp(world_state_buffer[1]["B"][bullet]["pos"], world_state_buffer[2]["B"][bullet]["pos"], interpolation_factor)
			var current_rot = (world_state_buffer[1]["B"][bullet]["rot"]).get_rotation_quat()
			var target_rot = (world_state_buffer[2]["B"][bullet]["rot"]).get_rotation_quat()
			modified_data["rot"] = Basis(current_rot.slerp(target_rot, interpolation_factor))
			update_bullet_inside_the_collection(bullet, modified_data)
		else:
			add_bullet_to_the_collection(bullet, world_state_buffer[2]["B"][bullet])
	for bullet in bullet_collection:
		if not world_state_buffer[2]["B"].keys().has(bullet):
			remove_bullet_from_the_collection(bullet)


	for loot in world_state_buffer[2]["L"]:
		print(loot)



func extrapolate(_render_time):
	var extrapolation_factor = float(_render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
	# PLAYERS
	for pc in world_state_buffer[1]["P"].keys():
		if not world_state_buffer[0]["P"].has(pc): # WE WANT TO BE SURE THAT BOTH WS0 AND WS1 HAVE ANY GIVEN KEY FOR EXTRAPOLATION'S SAKE
			continue
		if pc_collection.has(pc):
			var modified_data := {}
			var position_delta = (world_state_buffer[1]["P"][pc]["pos"] - world_state_buffer[0]["P"][pc]["pos"])
			modified_data["pos"] = world_state_buffer[1]["P"][pc]["pos"] + (position_delta * extrapolation_factor)
			var current_rot = (world_state_buffer[1]["P"][pc]["rot"]).get_rotation_quat()
			var old_rot = (world_state_buffer[0]["P"][pc]["rot"]).get_rotation_quat()
			var rotation_delta = (current_rot - old_rot)
			modified_data["rot"] = Basis(current_rot + (rotation_delta * extrapolation_factor))
			update_pc_inside_the_collection(pc, modified_data)

	# ENEMIES
	for npc in world_state_buffer[1]["E"].keys():
		if not world_state_buffer[0]["E"].has(npc): # WE WANT TO BE SURE THAT BOTH WS0 AND WS1 HAVE ANY GIVEN KEY FOR EXTRAPOLATION'S SAKE
			continue
		if npc_collection.has(npc):
			var modified_data := {}
			var position_delta = (world_state_buffer[1]["E"][npc]["pos"] - world_state_buffer[0]["E"][npc]["pos"])
			modified_data["pos"] = world_state_buffer[1]["E"][npc]["pos"] + (position_delta * extrapolation_factor)
			var current_rot = (world_state_buffer[1]["E"][npc]["rot"]).get_rotation_quat()
			var old_rot = (world_state_buffer[0]["E"][npc]["rot"]).get_rotation_quat()
			var rotation_delta = (current_rot - old_rot)
			modified_data["rot"] = Basis(current_rot + (rotation_delta * extrapolation_factor))
			update_npc_inside_the_collection(npc, modified_data)

	# BULLET
	for bullet in world_state_buffer[1]["B"].keys():
		if not world_state_buffer[0]["B"].has(bullet): # WE WANT TO BE SURE THAT BOTH WS0 AND WS1 HAVE ANY GIVEN KEY FOR EXTRAPOLATION'S SAKE
			continue
		if bullet_collection.has(bullet):
			var modified_data := {}
			var position_delta = (world_state_buffer[1]["B"][bullet]["pos"] - world_state_buffer[0]["B"][bullet]["pos"])
			modified_data["pos"] = world_state_buffer[1]["B"][bullet]["pos"] + (position_delta * extrapolation_factor)
			var current_rot = (world_state_buffer[1]["B"][bullet]["rot"]).get_rotation_quat()
			var old_rot = (world_state_buffer[0]["B"][bullet]["rot"]).get_rotation_quat()
			var rotation_delta = (current_rot - old_rot)
			modified_data["rot"] = Basis(current_rot + (rotation_delta * extrapolation_factor))
			update_bullet_inside_the_collection(bullet, modified_data)
