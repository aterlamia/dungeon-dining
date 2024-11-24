class_name CustomerOrder

var _customer: Npc = null
var _dish: String = ""
var _cooking_time: float = 0.0
var _model: String = ""
var _image: String = ""
var _curPos: float = 0.0

func _ready() -> void:
	pass
	
var customer: Npc:
	get:
		return _customer
	set(value):
		_customer = value

var dish: String:
	get:
		return _dish
	set(value):
		_dish = value

var cooking_time: float:
	get:
		return _cooking_time
	set(value):
		_cooking_time = value

var model: String:
	get:
		return _model
	set(value):
		_model = value

var image: String:
	get:
		return _image
	set(value):
		_image = value

var curPos: float:
	get:
		return _curPos
	set(value):
		_curPos = value

static func create_order(customer:Npc, dish: String, cooking_time: float, model:String, image: String) -> CustomerOrder:
	var order = CustomerOrder.new()
	order.customer = customer
	order.dish = dish
	order.cooking_time = cooking_time
	order.model = model
	order.image = image
	order.curPos = -1
 
	return order
	
	
