extends Node

#############################################################################################################
# modified code from Chili-Turtle:                                                                          #
# https://github.com/Chili-Turtle/Godot-simple-a_star-pathfinding/blob/master/a_star%20pathfinding/astar.gd #
#############################################################################################################

var map = []
var mapWidth = 0
var mapHeight = 0

var dominationOrder = ""

var startNode = Vector2(0,0)
var endNode = Vector2(0,0)


func mbfs_init():
	# init map
	map = get_parent().map
	mapWidth = get_parent().mapWidth
	mapHeight = get_parent().mapHeight
	
	# dom order
	dominationOrder = get_parent().dominationOrder
	
	# init start & end node
	startNode = get_parent().startNode
	endNode = get_parent().endNode
	
	#start mbfs
	var path = []
	var highest_trap = "none"
	
	var mbfs_result : Array = modified_breadth_first_search(startNode, path, highest_trap)
	
	# get shortest path
	var shortest_path_to_goal = []
	
	if mbfs_result != []:
		shortest_path_to_goal = mbfs_result[0]
		
		for i in mbfs_result:
			if i.size() < shortest_path_to_goal.size():
				shortest_path_to_goal = i
	
	get_parent().draw_final_path(shortest_path_to_goal)
	get_parent().create_result(shortest_path_to_goal)
	#print("################# \n shortest path: " , shortest_path_to_goal)


func modified_breadth_first_search(currentStartNode, prev_path, highest_trap):
	#print("***************** \n mbfs iteration started")
	
	var paths_to_goal : Array = []
	
	var frontier : Dictionary = {}
	frontier[currentStartNode] = 0
	
	var came_from : Dictionary = {}
	came_from[currentStartNode] = []
	if prev_path != []:
		came_from[currentStartNode] = prev_path[0]
	
	var cost_so_far : Dictionary = {}
	cost_so_far[currentStartNode] = 0


	while !frontier.empty():
		
		var current = priority_list(frontier)
		frontier.erase(current)
		
		if current == endNode: #if at goal calculate path and bail-out
			#print("----------------------")
			#print("we reached the goal:")
			
			#current = endNode
			var path : Array = []
			while current != currentStartNode:
				path.append(current)
				current = came_from[current]
			path.append(currentStartNode)
			#path.invert()
			
			#print("path-length: " , path.size() + prev_path.size(), "; highest-trap-level: " , highest_trap)
			#print("paths to goal: " , path + prev_path)
			#print("path: " , path)
			#print("prev_path: " , prev_path)
			#print("----------------------")
			
			# must have reached the goal from the shortest distance to the current start node - no new trap was triggered
			return [path + prev_path]

		if is_trap(current) and not(current == currentStartNode):
			#print(current , " is a trap! cap is: " , highest_trap)
			if is_allowed_to_enter_trap(current, highest_trap):
				#print(">> new mbfs for trap at: " , current , ", with queue: " , frontier)
				
				# update highest triggered trap
				var local_highest_trap = map[current.x][current.y]
				
				# create new BFS that inherits the path so far and the cost so far
				var path : Array = []
				var path_helper = current
				
				path_helper = came_from[path_helper]
				while path_helper != currentStartNode:
					path.append(path_helper)
					path_helper = came_from[path_helper]
				path.append(currentStartNode)
				#path.invert()
				
				# recursive mbfs
				#print("passing path: " , path , "\n passing prev_pass: " , prev_path)
				var rec_mbfs_path# : Array = []
				rec_mbfs_path = modified_breadth_first_search(current, path + prev_path, local_highest_trap)
				
				# if BFS found a path to the goal, add it to all paths that reached the goal
				#print("======== \n current/after rec: " , current)
				#print("rec mbfs path: " , rec_mbfs_path)
				if rec_mbfs_path != []:
					for i in rec_mbfs_path:
						paths_to_goal.append(i)
				
				# dont add neighbours where a new iteration of mbfs has been started
				continue
			else:
				# if not a valid tile, carry on with the next one
				continue

		for next in get_neighbors(current): #loops throw neighbors and calculates the cost
			#print("/////////// \n next: " , next , ", current: " , current , ", came_from[current]: " , came_from[current])
			
			if current != startNode: # global startNode, bc special case of the first iteration
				if next == came_from[current]:
					continue
			
			var new_cost = cost_so_far[current] + 1
			if !next in cost_so_far or new_cost < cost_so_far[next]:
				cost_so_far[next] = new_cost
				frontier[next] = new_cost
				came_from[next] = current
				#yield(get_tree().create_timer(0.05), "timeout")
	
	# if no path to goal has been found return empty path
	#print("paths to goal: " , paths_to_goal)
	return paths_to_goal


func is_trap(current : Vector2):
	if map[current.x][current.y] != "x" and map[current.x][current.y] != "o":
		return true

func is_allowed_to_enter_trap(current : Vector2, highest_trap : String):
	var current_trap =  map[current.x][current.y]
	
	if highest_trap == "none":
		return true
	
	for i in dominationOrder:
		if i == current_trap:
			return false
		if i == highest_trap:
			return true
		


func get_neighbors(pos : Vector2): #helper function to get the neighbors
	var neighbors : Array = []
	
	if pos.x - 1 >= 0: # dont go out of bounds
		if map[pos.x - 1][pos.y] != "x": # not a wall
			neighbors.append(pos + Vector2(-1, 0)) # add neighbour
	
	if pos.x + 1 < mapWidth:
		if map[pos.x + 1][pos.y] != "x":
			neighbors.append(pos + Vector2(1, 0))
	
	if pos.y - 1 >= 0:
		if map[pos.x][pos.y - 1] != "x":
			neighbors.append(pos + Vector2(0, -1))
	
	if pos.y + 1 < mapHeight:
		if map[pos.x][pos.y + 1] != "x":
			neighbors.append(pos + Vector2(0, 1))
	
	return neighbors


func priority_list(dic : Dictionary): #list wich returns the key with the lowest priority
	var priority : Vector2 = Vector2(-1, -1)
	
	for key in dic:
		if priority == Vector2(-1, -1):
			priority = key
			continue
		if dic[priority] > dic[key]:
			priority = key
	
	return priority

