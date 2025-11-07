extends Control

# Game state
var faith: int = 1000  # Main currency for everything
var reputation: float = 2.5
var god_slots: int = 5
var mission_success_bonus: float = 0.0  # Increases min multiplier
var faith_multiplier: float = 1.0

# Collections
var all_gods: Array = []
var active_missions: Array = []
var available_missions: Array = []

# Random generation lists
var god_names: Array = [
	"God of Socks", "God of Beans", "God of Paperclips", "God of Mondays",
	"God of Lost Keys", "God of Burnt Toast", "God of Traffic Lights", "God of Hiccups",
	"God of Sneezes", "God of Typos", "God of Buffering", "God of Crumbs",
	"God of Lint", "God of Potholes", "God of Mosquitoes", "God of Static",
	"God of Splinters", "God of Hangnails", "God of Tangles", "God of Stubbed Toes",
	"God of Cold Calls", "God of Spam", "God of Autocorrect", "God of Loading Screens",
	"God of Wet Socks", "God of Brain Freeze", "God of Paper Cuts", "God of Elevator Music",
	"God of Crumpled Receipts", "God of Expired Coupons", "God of Tangled Cords", "God of Sticky Keyboards",
	"God of Flat Tires", "God of Dead Batteries", "God of Forgotten Passwords", "God of Broken Shoelaces",
	"God of Dusty Shelves", "God of Squeaky Hinges", "God of Leaky Faucets", "God of Burnt Popcorn",
	"God of Stubborn Jars", "God of Crooked Pictures", "God of Wrinkled Shirts", "God of Squeaky Floors",
	"God of Foggy Mirrors", "God of Tangled Earbuds", "God of Warm Pillows", "God of Lukewarm Coffee",
	"God of Stale Chips", "God of Wobbly Tables", "God of Creaky Chairs", "God of Dried Pens",
	"God of Stuck Zippers", "God of Missing Socks", "God of Cracked Screens", "God of Low Battery",
	"God of Bad WiFi", "God of Slow Downloads", "God of Frozen Apps", "God of Blue Screens",
	"God of 404 Errors", "God of Caps Lock", "God of Num Lock", "God of Scroll Lock",
	"God of Printer Jams", "God of Out of Ink", "God of Paper Jams", "God of Toner Low",
	"God of Copy Errors", "God of Scan Failures", "God of Fax Machines", "God of Busy Signals",
	"God of Voicemail", "God of Hold Music", "God of Wrong Numbers", "God of Pocket Dials",
	"God of Butt Dials", "God of Group Chats", "God of Read Receipts", "God of Typing Bubbles",
	"God of Left on Read", "God of Seen Notifications", "God of Unread Emails", "God of Spam Folders",
	"God of Reply All", "God of CC Everyone", "God of BCC Secrets", "God of Email Chains",
	"God of Attachment Limits", "God of File Size Errors", "God of Format Issues", "God of Compatibility",
	"God of Updates", "God of Restarts", "God of Forced Updates", "God of Terms and Conditions",
	"God of Cookie Popups", "God of Captchas", "God of Password Requirements", "God of Two Factor Auth"
]

var mission_names: Array = [
	"Get cat down from tree", "Pass my drivers exam", "Find lost remote control",
	"Make it stop raining at picnic", "Help find matching sock", "Unclog the toilet",
	"Fix squeaky door", "Remove gum from hair", "Get WiFi to work", "Find car keys",
	"Make toast not burn", "Stop dog from barking", "Find phone in couch", "Fix leaky faucet",
	"Get lid off jar", "Untangle Christmas lights", "Remove wine stain", "Fix flat tire",
	"Get ring out of drain", "Stop baby from crying", "Find TV remote", "Fix broken zipper",
	"Get gum off shoe", "Remove splinter", "Fix creaky floorboard", "Get marker off wall",
	"Unclog printer", "Fix broken shoelace", "Get pen to work", "Find missing earring",
	"Fix wobbly table", "Get stain out of shirt", "Fix sticky door", "Remove crayon from wall",
	"Get bird out of house", "Fix broken glasses", "Find lost wallet", "Get ketchup stain out",
	"Fix computer that won't start", "Get raccoon out of attic", "Find lost homework",
	"Make computer faster", "Get better cell signal", "Find parking spot", "Make traffic go away",
	"Help win lottery", "Make crush like me back", "Get promotion at work", "Pass math test",
	"Win argument with spouse", "Get good hair day", "Make it not Monday", "Skip the line at DMV",
	"Get extra fries in order", "Make elevator come faster", "Get green lights all the way",
	"Make printer work for once", "Get package delivered on time", "Make meeting be cancelled",
	"Get out of jury duty", "Make dentist appointment disappear", "Skip family reunion",
	"Get good parking spot at mall", "Make internet faster", "Get waiter's attention",
	"Make phone battery last", "Get upgrade to first class", "Make rain stop for wedding",
	"Get snow day from school", "Make hangover go away", "Get reservation at full restaurant",
	"Make acne disappear", "Get date to text back", "Make Monday feel like Friday",
	"Get free shipping", "Make traffic light turn green", "Get good grade without studying",
	"Make boss not notice I'm late", "Get printer to work before meeting", "Make queue move faster",
	"Get good RNG in video game", "Make gacha pull be legendary", "Get critical hit",
	"Make enemy miss attack", "Get shiny Pokemon", "Make loot drop be rare",
	"Get perfect roll on stats", "Make matchmaking be fair", "Get good teammates",
	"Make lag go away", "Get server to not crash", "Make update download faster",
	"Get banned player unbanned", "Make nerf not happen", "Get buff for favorite character",
	"Make event not be grindy", "Get free premium currency", "Make dailies complete themselves",
	"Scare neighbors roommate", "Make plants grow faster", "Get better weather tomorrow",
	"Make coffee taste good", "Get motivation to exercise", "Make alarm not go off"
]

# UI References
@onready var faith_label = $MarginContainer/VBoxContainer/TopBar/FaithLabel
@onready var reputation_label = $MarginContainer/VBoxContainer/TopBar/ReputationLabel
@onready var missions_container = $MarginContainer/VBoxContainer/MainContent/MissionsPanel/VBoxContainer/ScrollContainer/VBoxContainer
@onready var gods_container = $MarginContainer/VBoxContainer/GodsPanel/VBoxContainer/ScrollContainer/HBoxContainer
@onready var upgrades_container = $MarginContainer/VBoxContainer/MainContent/UpgradesPanel/VBoxContainer/ScrollContainer/VBoxContainer
@onready var auto_play_button = $MarginContainer/VBoxContainer/ButtonsBar/AutoPlayButton
@onready var help_button = $MarginContainer/VBoxContainer/ButtonsBar/HelpButton
@onready var sort_str_button = $MarginContainer/VBoxContainer/GodsPanel/VBoxContainer/SortButtons/SortByStrength
@onready var sort_spd_button = $MarginContainer/VBoxContainer/GodsPanel/VBoxContainer/SortButtons/SortBySpeed
@onready var sort_int_button = $MarginContainer/VBoxContainer/GodsPanel/VBoxContainer/SortButtons/SortByIntelligence
@onready var message_label = $MarginContainer/VBoxContainer/MessageLabel
@onready var gods_title_label = $MarginContainer/VBoxContainer/GodsPanel/VBoxContainer/Label

# Timers
var mission_spawn_timer: float = 0.0
var mission_spawn_interval: float = 8.0  # Spawn missions every 8 seconds

# Selected items
var selected_mission = null
var selected_god = null

# Auto play
var auto_play_enabled: bool = false
var auto_play_timer: float = 0.0
var auto_play_interval: float = 1.0  # Check every second

# Message queue
var message_queue: Array = []
var current_message_timer: float = 0.0
var message_display_time: float = 5.0
var is_showing_message: bool = false

func _ready():
	randomize()
	# Start with 3 random gods
	for i in range(3):
		add_random_god()

	update_ui()
	setup_upgrades()

	# Connect buttons
	auto_play_button.toggled.connect(_on_auto_play_toggled)
	help_button.pressed.connect(_on_help_pressed)
	sort_str_button.pressed.connect(func(): sort_gods_by("strength"))
	sort_spd_button.pressed.connect(func(): sort_gods_by("speed"))
	sort_int_button.pressed.connect(func(): sort_gods_by("intelligence"))

func _process(delta):
	# Spawn missions randomly
	mission_spawn_timer += delta
	if mission_spawn_timer >= mission_spawn_interval:
		mission_spawn_timer = 0.0
		spawn_mission()

	# Update mission timers
	for mission in available_missions:
		mission.update_timer(delta)

	for mission in active_missions:
		mission.update_progress(delta)

	# Handle auto-play
	if auto_play_enabled:
		auto_play_timer += delta
		if auto_play_timer >= auto_play_interval:
			auto_play_timer = 0.0
			process_auto_play()

	# Handle message queue
	process_message_queue(delta)

	update_ui()

func spawn_mission():
	if available_missions.size() >= 10:  # Max 10 available missions
		return

	var mission = create_random_mission()
	available_missions.append(mission)
	missions_container.add_child(mission)

func create_random_mission():
	var mission_scene = preload("res://Mission.tscn")
	var mission = mission_scene.instantiate()

	var mission_name = mission_names[randi() % mission_names.size()]
	var difficulty = randi() % 5 + 1  # 1-5
	var recommended_stat = ["strength", "speed", "intelligence"][randi() % 3]
	var reward = difficulty * 100 * randf_range(0.8, 1.5)
	var completion_time = difficulty * 5.0 + randf_range(2.0, 8.0)
	var threshold = difficulty * 25.0 + randf_range(5.0, 20.0)  # 1-star: 30-45, 5-star: 130-145

	mission.setup(mission_name, difficulty, recommended_stat, int(reward), completion_time, threshold)
	mission.mission_clicked.connect(_on_mission_clicked)
	mission.mission_expired.connect(_on_mission_expired)
	mission.mission_completed.connect(_on_mission_completed)

	return mission

func add_random_god():
	if all_gods.size() >= god_slots:
		return false

	var god_scene = preload("res://God.tscn")
	var god = god_scene.instantiate()

	var god_name = god_names[randi() % god_names.size()]
	var strength = randi() % 101
	var speed = randi() % 101
	var intelligence = randi() % 101

	god.setup(god_name, strength, speed, intelligence)
	god.god_clicked.connect(_on_god_clicked)

	all_gods.append(god)
	gods_container.add_child(god)

	return true

func _on_mission_clicked(mission):
	# Deselect previous mission
	if selected_mission and selected_mission != mission:
		selected_mission.deselect()

	selected_mission = mission

	# If we have both mission and god selected, assign it
	if selected_god and selected_mission:
		assign_mission()

func _on_god_clicked(god):
	# Can't select gods that are busy
	if god.is_busy:
		return

	# Deselect previous god
	if selected_god and selected_god != god:
		selected_god.deselect()

	selected_god = god

	# If we have both mission and god selected, assign it
	if selected_god and selected_mission:
		assign_mission()

func assign_mission():
	if not selected_mission or not selected_god:
		return

	print("=== ASSIGNING MISSION ===")
	print("  Mission: ", selected_mission.mission_name)
	print("  God: ", selected_god.god_name)
	print("  Reward: ", selected_mission.reward)
	print("  Completion time: ", selected_mission.completion_time)

	# Remove from available missions
	available_missions.erase(selected_mission)
	active_missions.append(selected_mission)

	# Mark god as busy
	selected_god.set_busy(true)

	# Start mission
	selected_mission.start_mission(selected_god)

	# Clear selections
	selected_mission = null
	selected_god.deselect()
	selected_god = null

func _on_mission_expired(mission):
	# Mission disappeared without being completed
	available_missions.erase(mission)
	mission.queue_free()

	# Decrease reputation
	reputation = max(0.0, reputation - 0.1)

func _on_mission_completed(mission, god, success):
	print("=== _on_mission_completed CALLED ===")
	print("  Mission: ", mission.mission_name)
	print("  God: ", god.god_name)
	print("  Success: ", success)
	print("  Before - Faith: ", faith, " | Reputation: ", reputation)

	active_missions.erase(mission)

	if success:
		var actual_reward = int(mission.reward * faith_multiplier)
		print("  Reward calculation: ", mission.reward, " * ", faith_multiplier, " = ", actual_reward)

		var old_faith = faith
		var old_reputation = reputation

		faith += actual_reward
		reputation = min(5.0, reputation + 0.05)

		print("  After - Faith: ", faith, " (gained: ", faith - old_faith, ")")
		print("  After - Reputation: ", reputation, " (gained: ", reputation - old_reputation, ")")
		print("  FAITH GAINED: +", actual_reward, " (Total: ", faith, ")")

		# Add success message to queue
		add_message("Miracle Granted - %s - +%d Faith" % [mission.mission_name, actual_reward], Color(1.0, 0.84, 0.0))  # Gold color
	else:
		var old_reputation = reputation
		reputation = max(0.0, reputation - 0.05)
		print("  MISSION FAILED - No faith gained")
		print("  After - Reputation: ", reputation, " (lost: ", old_reputation - reputation, ")")

		# Add failure message to queue
		add_message("Miracle Busted - %s" % mission.mission_name, Color(1.0, 0.2, 0.2))  # Red color

	# Free the god
	god.set_busy(false)

	# Remove mission
	mission.queue_free()
	print("=== END _on_mission_completed ===")

func update_ui():
	if faith_label:
		faith_label.text = "Faith: %d" % faith
	if reputation_label:
		reputation_label.text = "Reputation: %.1f/5.0" % reputation
	if gods_title_label:
		gods_title_label.text = "Available Gods (%d/%d)" % [all_gods.size(), god_slots]

func setup_upgrades():
	add_upgrade("Buy Random God", 500, func(): return buy_random_god())
	add_upgrade("Buy God Slot", 1000, func(): return buy_god_slot())
	add_upgrade("Mission Success Bonus", 750, func(): return buy_success_bonus())
	add_upgrade("Faith Multiplier", 1000, func(): return buy_faith_multiplier())

func add_upgrade(upgrade_name: String, cost: int, callback: Callable):
	var upgrade = Button.new()
	upgrade.text = "%s (%d Faith)" % [upgrade_name, cost]
	upgrade.pressed.connect(func():
		if faith >= cost:
			if callback.call():
				faith -= cost
	)
	upgrades_container.add_child(upgrade)

func buy_random_god() -> bool:
	return add_random_god()

func buy_god_slot() -> bool:
	god_slots += 1
	return true

func buy_success_bonus() -> bool:
	if mission_success_bonus >= 0.5:
		return false
	mission_success_bonus += 0.01
	return true

func buy_faith_multiplier() -> bool:
	faith_multiplier += 0.1
	return true

func _on_auto_play_toggled(button_pressed: bool):
	auto_play_enabled = button_pressed
	if button_pressed:
		auto_play_button.text = "Auto Play: ON"
		auto_play_timer = 0.0  # Reset timer when turning on
	else:
		auto_play_button.text = "Auto Play: OFF"

func process_auto_play():
	# Get first available mission
	if available_missions.size() == 0:
		return

	var mission = available_missions[0]

	# Find the best available god for this mission
	var best_god = null
	var best_stat_value = -1

	for god in all_gods:
		if god.is_busy:
			continue

		var god_stat_value = 0
		match mission.recommended_stat:
			"strength":
				god_stat_value = god.strength
			"speed":
				god_stat_value = god.speed
			"intelligence":
				god_stat_value = god.intelligence

		if god_stat_value > best_stat_value:
			best_stat_value = god_stat_value
			best_god = god

	# If we found a suitable god, assign the mission
	if best_god:
		# Clear any existing selections
		if selected_mission:
			selected_mission.deselect()
		if selected_god:
			selected_god.deselect()

		# Set selections
		selected_mission = mission
		selected_god = best_god

		# Assign the mission
		assign_mission()

		print("AUTO-PLAY: Assigned '%s' to mission '%s' (recommended: %s)" % [best_god.god_name, mission.mission_name, mission.recommended_stat])

func _on_help_pressed():
	# Create help popup
	var popup = AcceptDialog.new()
	popup.title = "How to Play"
	popup.dialog_text = """Welcome to the Heavenly Miracle Hotline!

HOW TO PLAY:
• Select a mission on the right
• Then select a god at the bottom to assign them
• Wait for the mission to complete

GODS:
Gods have three attributes:
• Strength (Red)
• Speed (Blue)
• Intelligence (Green)

Match the god's strong attribute to the mission's recommended stat for better success rates!

CURRENCY:
• Complete missions to earn Faith
• Use Faith to buy upgrades on the left
• Maintain your reputation to keep the hotline running!"""

	popup.min_size = Vector2(400, 300)
	add_child(popup)
	popup.popup_centered()

func sort_gods_by(stat: String):
	# Sort all_gods array
	all_gods.sort_custom(func(a, b):
		var a_val = 0
		var b_val = 0
		match stat:
			"strength":
				a_val = a.strength
				b_val = b.strength
			"speed":
				a_val = a.speed
				b_val = b.speed
			"intelligence":
				a_val = a.intelligence
				b_val = b.intelligence
		return a_val > b_val  # Descending order
	)

	# Reorder children in the container
	for god in all_gods:
		gods_container.move_child(god, all_gods.find(god))

func add_message(text: String, color: Color):
	message_queue.append({"text": text, "color": color})

func process_message_queue(delta: float):
	if is_showing_message:
		current_message_timer += delta

		# Fade effect in the last second
		if current_message_timer >= message_display_time - 1.0:
			var fade_progress = (current_message_timer - (message_display_time - 1.0)) / 1.0
			message_label.modulate.a = 1.0 - fade_progress

		if current_message_timer >= message_display_time:
			is_showing_message = false
			message_label.text = ""
			message_label.modulate.a = 1.0
			current_message_timer = 0.0
	elif message_queue.size() > 0:
		# Show next message
		var next_message = message_queue.pop_front()
		message_label.text = next_message["text"]
		message_label.add_theme_color_override("font_color", next_message["color"])
		is_showing_message = true
		current_message_timer = 0.0
