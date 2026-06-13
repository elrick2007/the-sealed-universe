# ============================================================================
#  THE WEEPING WALLS — Milestone 0, Part B (GODOT 4.x / GDScript)
#  Kitchen look-test RUNTIME. Proves the four signature systems live:
#    1. Clay look      (imported from Blender glTF PBR + a claymation post step)
#    2. Breathing walls (per-wall vertex pulse, 5s in / 5s out, slows on a flag)
#    3. Lamp radius     (a small carried pool of warm light against deep dark)
#    4. The 2:47 event  (a clock; at 02:47 the recorder LED blooms + one capture)
#
#  SETUP (5 minutes, no scene-building by hand):
#    1. New Godot 4 project. Put kitchen_lab.glb in res://assets/ (Blender Part A
#       exports straight there if you point EXPORT_DIR at this project's assets).
#    2. Create one scene with a single Node3D root named "Lab".
#    3. Attach THIS script to that root node. Save scene as res://Lab.tscn. Run.
#  Everything else (player, camera, lamp, LED, clock, breathing) is built in
#  code at startup from the glb's tagged meshes — paste-and-run, like the
#  Blender rostrum script. No manual node wiring.
#
#  CONTROLS: WASD move, mouse look, ESC release mouse, F skip clock to 02:46:50,
#            E by the table = place/lift recorder (toggles whether it's "left
#            running" when 2:47 arrives).
# ============================================================================
extends Node3D

# ----- tuning -----
const GLB_PATH := "res://assets/kitchen_lab.glb"
const MOVE_SPEED := 2.4
const MOUSE_SENS := 0.0022
const LAMP_RANGE := 4.5          # the deficit-able radius; shrink this for the cellar later
const LAMP_ENERGY := 3.2
const CLOCK_SCALE := 900.0       # sim-seconds per real-second (fast clock for testing)
var clock_seconds := float(2*3600 + 30*60)   # start at 02:30 so 02:47 is ~17 min away (~1s at scale)
const BREATH_PERIOD_FAST := 10.0  # 5s in, 5s out
var breath_period := BREATH_PERIOD_FAST
var breathing_slowed := false     # set true post-"publication" to slow the house

var _player: CharacterBody3D
var _cam: Camera3D
var _lamp: OmniLight3D
var _walls: Array[MeshInstance3D] = []
var _wall_rest: Array[float] = []
var _recorder: Node3D
var _led: OmniLight3D
var _recorder_running := true
var _fired_247 := false
var _yaw := 0.0
var _pitch := 0.0
var _t := 0.0

func _ready() -> void:
	_build_environment()
	_load_room()
	_build_player()
	_build_lamp()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	print("[WW M0] Kitchen look-test running. Clock starts 02:30. F = jump to 02:46:50.")

# --- world: deep dark, no ambient. The manor is lit only by what you carry. ---
func _build_environment() -> void:
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.01, 0.012, 0.02)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.02, 0.025, 0.04)
	env.ambient_light_energy = 0.15
	env.fog_enabled = true
	env.fog_light_color = Color(0.02, 0.025, 0.035)
	env.fog_density = 0.06          # dark eats the lamp at distance = dread
	# subtle claymation post: tonemap + faint grain via adjustments
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.adjustment_enabled = true
	env.adjustment_saturation = 0.9
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)

func _load_room() -> void:
	var scene: PackedScene = load(GLB_PATH)
	if scene == null:
		push_error("Missing %s — run Blender Part A first." % GLB_PATH)
		return
	var room := scene.instantiate()
	add_child(room)
	# walk the imported tree, sort meshes by the ww_* custom props Blender wrote
	_scan(room)

func _scan(n: Node) -> void:
	if n is MeshInstance3D:
		var mi := n as MeshInstance3D
		# claymation surface tweak: clamp metallic, raise roughness on every imported mat
		for i in mi.get_surface_override_material_count():
			pass
		var m := mi.mesh
		if m and m.get_surface_count() > 0:
			var base := mi.get_active_material(0)
			if base is StandardMaterial3D:
				var sm := (base as StandardMaterial3D).duplicate()
				sm.roughness = clamp(sm.roughness + 0.15, 0.7, 1.0)
				sm.metallic = min(sm.metallic, 0.1)
				mi.set_surface_override_material(0, sm)
		# breathing walls (Blender tag ww_breathing)
		if mi.has_meta("ww_breathing") or _imported_extra(mi, "ww_breathing"):
			_walls.append(mi)
			_wall_rest.append(mi.position.x if absf(mi.position.x) > absf(mi.position.z) else mi.position.z)
		# recorder (Blender tag ww_recorder)
		if mi.has_meta("ww_recorder") or _imported_extra(mi, "ww_recorder"):
			_recorder = mi
			_attach_led(mi)
	# markers come in as Node3D named PlayerSpawn / LampSpot
	for c in n.get_children():
		_scan(c)

# Godot stores glTF 'extras' differently across versions; check both meta and name fallback
func _imported_extra(n: Node, key: String) -> bool:
	if n.has_meta(key): return true
	# fallback: the Blender names are distinctive enough
	if key == "ww_breathing" and n.name.begins_with("Wall_"): return true
	if key == "ww_recorder" and n.name == "Recorder": return true
	return false

# --- system 4 setup: the recorder's red LED -------------------------------
func _attach_led(host: Node3D) -> void:
	_led = OmniLight3D.new()
	_led.light_color = Color(1.0, 0.05, 0.03)
	_led.omni_range = 0.6
	_led.light_energy = 0.0      # dark until 02:47
	_led.position = Vector3(0, 0.05, 0)
	host.add_child(_led)
	# tiny emissive nub so the LED reads even when off-energy
	var nub := MeshInstance3D.new()
	var s := SphereMesh.new(); s.radius = 0.006; s.height = 0.012
	nub.mesh = s
	var em := StandardMaterial3D.new()
	em.emission_enabled = true
	em.emission = Color(0.4, 0.0, 0.0)
	em.emission_energy_multiplier = 1.0
	nub.material_override = em
	nub.name = "LED_nub"
	host.add_child(nub)

# --- player: a capsule + camera, built in code ----------------------------
func _build_player() -> void:
	_player = CharacterBody3D.new()
	var col := CollisionShape3D.new()
	var cap := CapsuleShape3D.new(); cap.height = 1.7; cap.radius = 0.3
	col.shape = cap
	_player.add_child(col)
	_cam = Camera3D.new()
	_cam.position = Vector3(0, 0.7, 0)   # eye height on the capsule
	_cam.fov = 55                        # the long-ish miniature-lens feel
	_player.add_child(_cam)
	add_child(_player)
	var spawn := get_node_or_null("%PlayerSpawn")
	if spawn == null:
		# find by name anywhere
		spawn = _find_by_name(self, "PlayerSpawn")
	_player.global_position = (spawn.global_position if spawn else Vector3(0, 1.0, -1.6))

func _build_lamp() -> void:
	_lamp = OmniLight3D.new()
	_lamp.light_color = Color(1.0, 0.72, 0.42)   # candle/oil warmth
	_lamp.omni_range = LAMP_RANGE
	_lamp.light_energy = LAMP_ENERGY
	_lamp.omni_attenuation = 1.6                 # tight falloff = carried pool
	_cam.add_child(_lamp)                         # the lamp travels with the eye
	_lamp.position = Vector3(0.25, -0.2, -0.2)

func _find_by_name(n: Node, nm: String) -> Node:
	if n.name == nm: return n
	for c in n.get_children():
		var r := _find_by_name(c, nm)
		if r: return r
	return null

# --- input ----------------------------------------------------------------
func _unhandled_input(e: InputEvent) -> void:
	if e is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_yaw -= e.relative.x * MOUSE_SENS
		_pitch = clamp(_pitch - e.relative.y * MOUSE_SENS, -1.4, 1.4)
	elif e is InputEventKey and e.pressed:
		if e.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif e.keycode == KEY_F:
			clock_seconds = float(2*3600 + 46*60 + 50)   # jump to 02:46:50
			print("[WW M0] Clock jumped to 02:46:50.")
		elif e.keycode == KEY_E:
			_toggle_recorder()

func _toggle_recorder() -> void:
	if _recorder == null: return
	if _player.global_position.distance_to(_recorder.global_position) < 1.6:
		_recorder_running = not _recorder_running
		print("[WW M0] Recorder %s." % ("LEFT RUNNING" if _recorder_running else "STOPPED / picked up"))

# --- per-frame: movement, look, breathing, clock, 2:47 --------------------
func _physics_process(delta: float) -> void:
	_t += delta
	# look
	if _cam:
		_player.rotation.y = _yaw
		_cam.rotation.x = _pitch
	# move
	var dir := Vector3.ZERO
	if Input.is_key_pressed(KEY_W): dir -= _player.global_transform.basis.z
	if Input.is_key_pressed(KEY_S): dir += _player.global_transform.basis.z
	if Input.is_key_pressed(KEY_A): dir -= _player.global_transform.basis.x
	if Input.is_key_pressed(KEY_D): dir += _player.global_transform.basis.x
	dir.y = 0
	_player.velocity = dir.normalized() * MOVE_SPEED
	_player.velocity.y -= 9.0 * delta   # gravity so the capsule sits on the floor
	_player.move_and_slide()

	_update_breathing()
	_update_clock(delta)

# system 2: breathing walls — push each wall along its inward normal on a sine
func _update_breathing() -> void:
	var period := breath_period * (2.0 if breathing_slowed else 1.0)
	var phase := sin(_t * TAU / period)
	for i in _walls.size():
		var w := _walls[i]
		# nudge ±2.5mm inward/outward along whichever axis the wall faces
		var amp := 0.0025
		if absf(w.position.x) > absf(w.position.z):
			var sign := -signf(w.position.x)
			w.position.x = _wall_rest[i] + sign * amp * phase
		else:
			var sign := -signf(w.position.z)
			w.position.z = _wall_rest[i] + sign * amp * phase

# systems 4: advance clock; bloom the LED + one capture at 02:47
func _update_clock(delta: float) -> void:
	clock_seconds += delta * CLOCK_SCALE
	if clock_seconds >= 24*3600: clock_seconds -= 24*3600
	var hh := int(clock_seconds) / 3600
	var mm := (int(clock_seconds) % 3600) / 60
	if hh == 2 and mm == 47 and not _fired_247:
		_fired_247 = true
		_event_247()

func _event_247() -> void:
	print("[WW M0] 02:47. The house speaks.")
	if _recorder_running and _led:
		# the ember bloom + a flicker, then a held glow
		var tw := create_tween()
		tw.tween_property(_led, "light_energy", 1.6, 0.4)
		tw.tween_property(_led, "light_energy", 0.3, 0.15)
		tw.tween_property(_led, "light_energy", 1.2, 0.25)
		print("[WW M0] Recorder was running -> 42 seconds captured. (audio hook here)")
		# AUDIO HOOK: play your 2:47 yield file. Placeholder generates a sub tone.
		_play_placeholder_247()
	else:
		print("[WW M0] Recorder was NOT running -> the moment passed uncaptured.")

func _play_placeholder_247() -> void:
	var p := AudioStreamPlayer.new()
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = 22050.0
	gen.buffer_length = 0.5
	p.stream = gen
	add_child(p)
	p.play()
	var pb: AudioStreamGeneratorPlayback = p.get_stream_playback()
	# a low, thickening hum — stand-in for the room-tone signature
	var frames := int(gen.mix_rate * 0.5)
	for i in frames:
		var s := 0.18 * sin(TAU * 47.0 * float(i) / gen.mix_rate)
		pb.push_frame(Vector2(s, s))
