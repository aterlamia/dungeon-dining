class_name Dispencer

extends Node3D

var order_queue: Array[CustomerOrder] = []
var done_order_queue: Array[CustomerOrder] = []
var chefs: Array = []
var num_chefs: int = 2
var wantsManager: WantsManager
@export var dishPositions: Array[Marker3D]

func _ready() -> void:
	wantsManager = get_node("/root/Wants")
	get_node("/root/Events").customer_seated.connect(_on_customer_seated)
	get_node("/root/Events").cooking_done.connect(_on_cooking_done)
	for i in range(num_chefs):
		var cooking_timer = Timer.new()
		cooking_timer.set_one_shot(false)
		cooking_timer.connect("timeout", Callable(self, "_on_cooking_timer_timeout"))
		add_child(cooking_timer)
		chefs.append({
			"timer": cooking_timer,
			"current_order": null
		})


func _on_cooking_done(order) -> void:	
	done_order_queue.append(order)
	_updateQueue()
	pass

func _updateQueue():
	# remove all childern from the positions
	for pos in dishPositions:
		if pos.get_child_count() != 0:
			var child: Node3D = pos.get_child(0)
			pos.remove_child(child)
			child.queue_free()
	if done_order_queue.size() > 0:
		var i = 0
		for doneOrder in done_order_queue:
			if(i<=dishPositions.size()):
				var pos = dishPositions[i]
				
				if pos.get_child_count() != 0:
					pos.get_child(0).queue_free()
					
				var order_scene = load(doneOrder['model'])
				var dish: Node3D = order_scene.instantiate()
				pos.add_child(dish) 
				i += 1
		pass
	
			
func _on_customer_seated(customer: Npc) -> void:
	var order = CustomerOrder.create_order(customer, customer.want, wantsManager.getWantData(customer.want).cookingTime, wantsManager.getWantData(customer.want).model, wantsManager.getWantData(customer.want).image)
	order_queue.append(order)
	_process_next_order()

func _process_next_order() -> void:
	for chef in chefs:
		if chef["current_order"] == null and order_queue.size() > 0:
			chef["current_order"] = order_queue.pop_front()
			chef["start_time"] = Time.get_ticks_msec() / 1000.0
			chef["cooking_time"] = chef["current_order"].cooking_time

func pickup():
	if done_order_queue.size() > 0:
		var order = done_order_queue.pop_front()
		_updateQueue()
		return order
	else:
		print("nope")
		return null
	
func _process(_delta: float) -> void:
	var current_time = Time.get_ticks_msec() / 1000.0
	for chef in chefs:
		if chef["current_order"] != null:
			var elapsed_time = current_time - chef["start_time"]
			var progress = elapsed_time / chef["cooking_time"]
			if elapsed_time >= chef["cooking_time"]:
				get_node("/root/Events").on_cooking_done(chef["current_order"])
				chef["current_order"] = null
				_process_next_order()
				
	
			
	
	
	
