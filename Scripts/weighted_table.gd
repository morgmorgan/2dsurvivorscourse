class_name WeightedTable

var items : Array[Dictionary] = []
var weight_sum = 0

func add_item(item, weight : int):
	items.append({"item" : item, "weight" : weight})
	weight_sum += weight
	
func remove_item():
	pass

func pick_item():
	var generated_weight = randi_range(1, weight_sum)
	
	var iteration_sum = 0
	for this_item in items:
		iteration_sum += this_item["weight"]
		if generated_weight <= iteration_sum:
			return this_item["item"]
