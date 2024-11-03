class_name Dispencer

extends Node3D

var order_queue: Array = []
var done_order_queue: Array = []
var chefs: Array = []
var num_chefs: int = 2
var indicator: MeshInstance3D
var wantsManager: WantsManager

func _ready() -> void:
	wantsManager = get_node("/root/Wants")
	get_node("/root/Events").customer_seated.connect(_on_customer_seated)
	indicator = get_node("Indicator")
	for i in range(num_chefs):
		var cooking_timer = Timer.new()
		cooking_timer.set_one_shot(false)
		cooking_timer.connect("timeout", Callable(self, "_on_cooking_timer_timeout"))
		add_child(cooking_timer)
		chefs.append({
			"timer": cooking_timer,
			"current_order": null
		})

func _on_customer_seated(customer: Npc) -> void:

	var order = {
		"customer": customer,	
		"dish": customer.want,
		"cooking_time": wantsManager.getWantData(customer.want).cookingTime,
		"wants_color": wantsManager.getWantData(customer.want).color
	}
	order_queue.append(order)
	_process_next_order()

func _process_next_order() -> void:
	for chef in chefs:
		if chef["current_order"] == null and order_queue.size() > 0:
			chef["current_order"] = order_queue.pop_front()
			chef["start_time"] = Time.get_ticks_msec() / 1000.0
			chef["cooking_time"] = chef["current_order"].cooking_time
			print("Started cooking: %s for %s" % [chef["current_order"].dish, chef["current_order"].customer.name])

func pickup():
	if done_order_queue.size() > 0:
		indicator.visible = false
		var order = done_order_queue.pop_front()
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
				done_order_queue.append(chef["current_order"])
				print("Finished cooking: %s for %s" % [chef["current_order"].dish, chef["current_order"].customer.name])
				chef["current_order"] = null
				_process_next_order()
				
	if done_order_queue.size() > 0 && indicator.visible == false:
		indicator.visible = true
		indicator.mesh.material.albedo_color = done_order_queue[0].wants_color
				