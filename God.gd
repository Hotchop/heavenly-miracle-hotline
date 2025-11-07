extends TextureRect

signal god_clicked(god)

var god_name: String
var strength: int
var speed: int
var intelligence: int
var is_busy: bool = false
var is_selected: bool = false

@onready var name_label = $NameLabel
@onready var stats_label = $StatsLabel

func setup(p_name: String, p_strength: int, p_speed: int, p_intelligence: int):
	god_name = p_name
	strength = p_strength
	speed = p_speed
	intelligence = p_intelligence

func _ready():
	if name_label:
		update_display()

	# Make it clickable
	gui_input.connect(_on_gui_input)

func update_display():
	name_label.text = god_name

	# Color-coded stats: Strength (red), Intelligence (green), Speed (blue)
	stats_label.clear()
	stats_label.push_bold()
	stats_label.push_color(Color(1.0, 0.4, 0.4))  # Light red for Strength
	stats_label.add_text("%d " % strength)
	stats_label.pop()
	stats_label.pop()
	stats_label.push_bold()
	stats_label.push_color(Color(0.4, 1.0, 0.4))  # Light green for Intelligence
	stats_label.add_text("%d " % intelligence)
	stats_label.pop()
	stats_label.pop()
	stats_label.push_bold()
	stats_label.push_color(Color(0.4, 0.6, 1.0))  # Light blue for Speed
	stats_label.add_text("%d" % speed)
	stats_label.pop()
	stats_label.pop()

	if is_busy:
		name_label.text = "%s (BUSY)" % god_name
		modulate = Color(0.5, 0.5, 0.5, 1.0)  # Gray out when busy
	elif is_selected:
		modulate = Color(1.2, 1.2, 0.8, 1.0)  # Highlight when selected
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)

func set_busy(busy: bool):
	is_busy = busy
	update_display()

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_busy:
			is_selected = true
			update_display()
			god_clicked.emit(self)

func deselect():
	is_selected = false
	update_display()
