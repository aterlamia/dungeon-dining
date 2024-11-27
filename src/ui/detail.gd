extends Panel

var global: GlobalState = null
var buyAmount = 0
var sellAmount = 0
var baseNode = null
var current: String = ""
var events: EventManager = null
func _ready():
	events = get_node("/root/Events")
	events.ingredient_selected.connect(_on_ingredient_selected)
	global = get_node("/root/Global")
	pass
	
func _on_ingredient_selected(ingredient: String) -> void:
	baseNode =  get_node("VBoxContainer/CenterContainer/MarginContainer/HBoxContainer/TileLetterContainer/NameContainer")
	var ingredientLabel = baseNode.get_node("name")
	var descLabel = baseNode.get_node("desc")
	var buyLabel = baseNode.get_node("buy")
	var sellLabel = baseNode.get_node("sell")
	ingredientLabel.text = ingredient
	current = ingredient
	
	var ingredientObject = global.getIngredient(ingredient)
	descLabel.text = ingredientObject.description
	buyLabel.text = "Buy: $" + str(ingredientObject.price)
	sellLabel.text = "Sell: $" + str(ingredientObject.price * 0.8)
	pass


func _on_buy_button_pressed() -> void:
	buy_ingredients(current, buyAmount)
	buyAmount = 0
	
	pass # Replace with function body.


func _on_sel_button_pressed() -> void:
	sell_ingredients(current, sellAmount)
	sellAmount = 0
	pass # Replace with function body.


func getMinimum() -> int:
	return floor(global.money / global.getIngredient(current).price)

	
func _on_add_buy_pressed() -> void:
	if current == "":
		return
	buyAmount += 1
	var min_amount = getMinimum()
	buyAmount = min(buyAmount, min_amount) if min_amount != null else 0
	
	baseNode.get_node("Buy/BuyTextEdit").text = str(buyAmount)
	pass

func _on_remove_buy_pressed() -> void:
	if current == "":
		return
	buyAmount -= 1
	if buyAmount < 0:
		buyAmount = 0
		pass
	baseNode.get_node("Buy/BuyTextEdit").text = str(buyAmount)
	pass
	
func _on_add_sell_pressed() -> void:
	if current == "":
		return
	var available_amount = global.game_state["ingredientsHold"].get(current, 0)
	sellAmount += 1
	print(sellAmount, available_amount)
	sellAmount = min(sellAmount, available_amount) if available_amount != null else 0
	
	baseNode.get_node("Sell/SellTextEdit").text = str(sellAmount)
	pass

func _on_remove_sell_pressed() -> void:
	if current == "":
		return
	sellAmount -= 1
	if sellAmount < 0:
		sellAmount = 0
		pass
	baseNode.get_node("Sell/SellTextEdit").text = str(sellAmount)
	pass
	
	
func buy_ingredients(ingredient: String, amount: int) -> void:
	var totalCost = amount * global.getIngredient(ingredient).price
	
	if global.money < totalCost:
		return
	global.money = global.money - totalCost
	events.on_money_changed(global.money)
	global.game_state["ingredientsHold"][ingredient] += amount
	events.on_ingredients_updated()

func sell_ingredients(ingredient: String, amount: int) -> void:
	if global.game_state["ingredientsHold"].get(ingredient, 0) < amount:
		return
		
	global.money = global.money + amount * global.getIngredient(ingredient).price
	events.on_money_changed(global.money)
	global.game_state["ingredientsHold"][ingredient] -= amount
	events.on_ingredients_updated()
