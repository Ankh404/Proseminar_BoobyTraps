extends Control

var is_already_running = false
var selected_input = "sampleinput0.txt"


func _ready():
	ui_set_up()

func ui_set_up():
	# set up UI
	$StartButton.connect("pressed", self, "button_start")
	$QuitButton.connect("pressed", self, "button_quit")
	$Panel/ResultMsg/Button.connect("pressed", self, "button_result_msg")
	
	$InputSelection.connect("item_selected", self, "obutton_input_selection")
	$InputSelection.add_item("Sample Input 0", 0)
	$InputSelection.add_item("Sample Input 1", 1)
	$InputSelection.add_item("Sample Input 2", 2)
	$InputSelection.add_item("Sample Input 3", 3)
	$InputSelection.add_item("Sample Input 4", 4)
	$InputSelection.add_item("Sample Input 5", 5)
	$InputSelection.add_item("Sample Input 6", 6)
	$InputSelection.add_item("Sample Input 7", 7)
	$InputSelection.add_item("Sample Input 8", 8)
	$InputSelection.add_item("Sample Input 9", 9)
	
	$InputSelection.select(0)
	input_refresh()

func input_refresh():
	for child in $Panel/TombCanvas.get_children():
		child.queue_free()
	
	$Backend.change_input(selected_input)

func button_start():
	if is_already_running == false:
		$Backend.run_mbfs()
		is_already_running = true

func button_quit():
	get_tree().quit()

func button_result_msg():
	# remove the message window
	$Panel/ResultMsg.visible = false
	$Panel/ResultMsg/Label.text = ""
	
	# allow use of the start button
	is_already_running = false

func result_msg(path : Array):
	$Panel/ResultMsg.visible = true
	
	if path.size() > 1:
		$Panel/ResultMsg/Label.text = "Goal reached in " + str(path.size()) + " steps."
	else:
		$Panel/ResultMsg/Label.text = "No possible path!"

func draw_final_path(path):
	$Panel/TombCanvas.draw_final_path(path)

func create_map(startNode, endNode, map):
	$Panel/TombCanvas.create_map(startNode, endNode, map)

func obutton_input_selection(item):
	selected_input = "sampleinput" + str(item) + ".txt"
	input_refresh()
