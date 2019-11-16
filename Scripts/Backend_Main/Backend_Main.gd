extends Node2D

# Declare member variables here.
var dominationOrder = ""

# the map/graph
var mapWidth = -1
var mapHeight = -1

var map = [] # FOR MATRIX-BASED ALGORITHEMS (ex. A*)

#var setOfNodes = [] # FOR GRAPH-BASED ALGORITHEMS (ex. Dijkstra)
#var setOfEdges = [] #

# start & end node
var startNode = Vector2(-1, -1)
var endNode = Vector2(-1, -1)


func change_input(input_file_name):
	$Parser.inputFileName = input_file_name
	$Parser.parseInputFile()


func run_mbfs():
	#print("MBFS mit " , startNode, endNode, map)
	
	# mbfs = modified breadth first search
	$"Breadth-First-Algorithm".mbfs_init()


func draw_final_path(path):
	get_parent().draw_final_path(path)

func create_result(path):
	get_parent().result_msg(path)

func create_map():
	get_parent().create_map(startNode, endNode, map)


func debug():
	# debug input parsing
	
	#get_child(0).parseInputFile()
	
	print("BM/ dom: " , dominationOrder)
	print("BM/ mW: " , mapWidth)
	print("BM/ mH: " , mapHeight)
	print("BM/ map" , map)
	#print("BM/ Nodes: " , setOfNodes)
	#print("BM/ Edges: " , setOfEdges)
	print("BM/ sNode: " , startNode.x , " / " , startNode.y)
	print("BM/ eNode: " , endNode.x , " / " , endNode.y)