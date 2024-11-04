class_name Order

var customer: Npc
var dish: String
var cooking_time: float
var wants_color: Color

func _init(customer: Npc, dish: String, cooking_time: float) -> void:
    self.customer = customer
    self.dish = dish
    self.cooking_time = cooking_time
    self.wants_color = Color(1, 1, 1)