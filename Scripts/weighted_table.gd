class_name WeightedTable

var items : Array[Dictionary] = []
var weight_sum = 0

func add_item(item, weight : int):
	items.append({"item" : item, "weight" : weight})
	weight_sum += weight
	
func remove_item(item_to_remove):
	items = items.filter(func(item): return item["item"] != item_to_remove)
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]

func pick_item(exclude : Array = []):
	var adjusted_items : Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum
	
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0
		for item in items:
			if not item["item"] in exclude:
				adjusted_items.append(item)
				adjusted_weight_sum += item["weight"]
	
	var generated_weight = randi_range(1, adjusted_weight_sum)
	
	var iteration_sum = 0
	for this_item in adjusted_items:
		iteration_sum += this_item["weight"]
		if generated_weight <= iteration_sum:
			return this_item["item"]
