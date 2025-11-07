extends PanelContainer

signal mission_clicked(mission)
signal mission_expired(mission)
signal mission_completed(mission, god, success)

var mission_name: String
var difficulty: int
var recommended_stat: String
var reward: int
var completion_time: float
var threshold: float

var expiry_timer: float = 20.0  # Disappears after 20 seconds
var progress_timer: float = 0.0
var is_active: bool = false
var assigned_god = null
var is_selected: bool = false

@onready var name_label = $MarginContainer/VBoxContainer/NameLabel
@onready var difficulty_label = $MarginContainer/VBoxContainer/DifficultyLabel
@onready var stat_label = $MarginContainer/VBoxContainer/StatLabel
@onready var reward_label = $MarginContainer/VBoxContainer/RewardLabel
@onready var time_label = $MarginContainer/VBoxContainer/TimeLabel

func setup(p_name: String, p_difficulty: int, p_stat: String, p_reward: int, p_time: float, p_threshold: float):
	mission_name = p_name
	difficulty = p_difficulty
	recommended_stat = p_stat
	reward = p_reward
	completion_time = p_time
	threshold = p_threshold

func _ready():
	if name_label:
		update_display()

	# Make it clickable
	gui_input.connect(_on_gui_input)

func update_display():
	name_label.text = mission_name
	difficulty_label.text = "Difficulty: %s" % get_difficulty_stars()
	stat_label.text = "Needs: %s" % recommended_stat.capitalize()
	reward_label.text = "Reward: %d Faith" % reward

	if is_active:
		time_label.text = "Time left: %.1fs" % (completion_time - progress_timer)
		if assigned_god:
			name_label.text = "%s (ASSIGNED TO %s)" % [mission_name, assigned_god.god_name]
	else:
		time_label.text = "Time: %.1fs | Expires: %.1fs" % [completion_time, expiry_timer]

	# Visual feedback for selection
	if is_selected:
		add_theme_stylebox_override("panel", get_selected_style())
	else:
		remove_theme_stylebox_override("panel")

func get_difficulty_stars() -> String:
	var stars = ""
	for i in range(difficulty):
		stars += "★"
	return stars

func get_selected_style():
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.3, 0.5, 0.8, 1.0)
	style.border_color = Color(1.0, 1.0, 0.0, 1.0)
	style.border_width_left = 3
	style.border_width_right = 3
	style.border_width_top = 3
	style.border_width_bottom = 3
	return style

func update_timer(delta: float):
	if not is_active:
		expiry_timer -= delta
		if expiry_timer <= 0:
			print("Mission EXPIRED: ", mission_name)
			mission_expired.emit(self)
		update_display()

func update_progress(delta: float):
	if is_active:
		progress_timer += delta
		if progress_timer >= completion_time:
			complete_mission()
		update_display()

func start_mission(god):
	is_active = true
	assigned_god = god
	progress_timer = 0.0
	deselect()
	update_display()

func complete_mission():
	# Calculate success
	var god_stat_value = 0
	match recommended_stat:
		"strength":
			god_stat_value = assigned_god.strength
		"speed":
			god_stat_value = assigned_god.speed
		"intelligence":
			god_stat_value = assigned_god.intelligence

	# Get success bonus from main
	var main = get_tree().root.get_node("Main")
	var min_multiplier = 1.0 + main.mission_success_bonus
	var max_multiplier = 2.0

	var multiplier = randf_range(min_multiplier, max_multiplier)
	var result = god_stat_value * multiplier

	var success = result >= threshold

	print("Mission COMPLETED: ", mission_name)
	print("  God stat (", recommended_stat, "): ", god_stat_value)
	print("  Multiplier: ", multiplier)
	print("  Result: ", result, " vs Threshold: ", threshold)
	print("  SUCCESS: ", success, " | Reward: ", reward)

	mission_completed.emit(self, assigned_god, success)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_active:  # Can only click on available missions
			is_selected = true
			update_display()
			mission_clicked.emit(self)

func deselect():
	is_selected = false
	update_display()
