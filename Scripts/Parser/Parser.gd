extends Node

var inputFileName = ""


func parseInputFile():
	var inputFile = File.new()
	var inputLine = []
	
	var mapHeight = -1
	var mapWidth = -1
	
	var map = []
	var map_corrected = []
	
	#var graphNodes = []
	#var graphEdges = []
	
	
	inputFile.open("res://Input/" + inputFileName, File.READ)
	
	# get & set domination order as string
	get_parent().dominationOrder = inputFile.get_line()
	
	
	# mapWidth & mapHeight
	inputLine = inputFile.get_line().split(" ", true, 0)
	
	mapWidth = int(inputLine[0])
	get_parent().mapWidth = mapWidth
	
	mapHeight = int(inputLine[1])
	get_parent().mapHeight = mapHeight
	
	
	# create matrix
	for i in range(mapHeight):
		var mapRow = inputFile.get_line()
		map.append([])
		
		for j in range(mapWidth):
			map[i].append(mapRow[j])
	
	# fix x/y axis
	for i in range(mapWidth):
		map_corrected.append([])
		
		for j in range(mapHeight):
			map_corrected[i].append(map[j][i])
	
	# set the map
	get_parent().map = map_corrected
	
	# set the nodes -- not in use for A*
	#graphNodes = graphCalcNodes(mapWidth, mapHeight, map)
	#get_parent().setOfNodes = graphNodes
	
	# set the edges -- not in use for A*
	#graphEdges = graphCalcEdges(graphNodes)
	#get_parent().setOfEdges = graphEdges
	
	
	# start pos
	inputLine = inputFile.get_line().split(" ", true, 0)
	get_parent().startNode.x = float(inputLine[0])
	get_parent().startNode.y = float(inputLine[1])
	
	
	# end pos
	inputLine = inputFile.get_line().split(" ", true, 0)
	get_parent().endNode.x = float(inputLine[0])
	get_parent().endNode.y = float(inputLine[1])
	
	
	get_parent().create_map()
	inputFile.close()


func graphCalcNodes(mapWidth, mapHeight, map):
	var graphNodes = []
	
	# calc nodes
	for i in mapWidth:
		for j in mapHeight:
			if map[i][j] != "x":
				graphNodes.append([i, j, map[i][j]])
	
	return graphNodes


func graphCalcEdges(nodes):
	var graphEdges = []
	
	# create matrix with right size
	for i in nodes.size() - 1:
		graphEdges.append([])
		
		for j in nodes.size() - 1:
			graphEdges[i].append([])
	
	# calc edges
	for i in nodes.size() - 1:
		var node1 = nodes[i]
		
		for j in nodes.size() - 1:
			var node2 = nodes[j]
			
			#    neighbours on x-axis                                                             or   neighbours on y-axis
			if ((node2[0] == node1[0] + 1 or node2[0] == node1[0] - 1) and node2[1] == node1[1])  or  (node2[1] == node1[1] + 1 or node2[1] == node1[1] - 1 and node2[0] == node1[0]):
				graphEdges[i][j] = 1
				graphEdges[j][i] = 1
			else:
				graphEdges[i][j] = 0
				graphEdges[j][i] = 0
	
	return graphEdges
	




	
	
	
	
	
	
	
	
	
	
	
	
	