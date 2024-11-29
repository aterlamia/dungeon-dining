extends Panel

var global: GlobalState = null
var buyAmount = 0
var sellAmount = 0
var baseNode = null
var current: String = ""
var events: EventManager = null

var ingredientLabel :Label
var descLabel: Label
var buyLabel : Label
var sellLabel : Label
var amountLabel : Label

func _ready():
	events = get_node("/root/Events")
	events.ingredient_selected.connect(_on_ingredient_selected)
	global = get_node("/root/Global")
	
	baseNode =  get_node("VBoxContainer/CenterContainer/MarginContainer/HBoxContainer/TileLetterContainer/NameContainer")
	ingredientLabel = baseNode.get_node("name")
	descLabel = baseNode.get_node("desc")
	buyLabel = baseNode.get_node("buy")
	sellLabel = baseNode.get_node("sell")
	amountLabel = baseNode.get_node("amount")
	
	baseNode.visible = false
	get_node("/root/Events").ingredients_updated.connect(_on_ingredients_updated)
	pass # Replace with function body.


func _on_ingredients_updated():
	if(current == ""):
		return
	var available_amount = global.game_state["ingredientsHold"].get(current, 0)
	amountLabel.text = "Current stock:  " + str(available_amount)


func _on_ingredient_selected(ingredient: String) -> void:
	
	var available_amount = global.game_state["ingredientsHold"].get(ingredient, 0)
	ingredientLabel.text = ingredient
	current = ingredient
	
	var ingredientObject = global.getIngredient(ingredient)
	descLabel.text = ingredientObject.description
	buyLabel.text =    "Buy:           $" + str(ingredientObject.price)
	sellLabel.text =   "Sell:          $" + str(ingredientObject.price * 0.8)
	amountLabel.text = "Current stock:  " + str(available_amount)
	baseNode.visible = true
	pass


func _on_buy_button_pressed() -> void:
	
	if get_node("/root/Global").inTutorial and current != "milk":
		return
	buy_ingredients(current, buyAmount)
	
	var available_amount = global.game_state["ingredientsHold"].get(current, 0)
	if get_node("/root/Global").inTutorial and current == "milk" and available_amount == 3:
		get_node("/root/Events").on_tutorial_switch(11)
        		
        		
	buyAmount = 0
	baseNode.get_node("Buy/BuyTextEdit").text = str(buyAmount)
	pass # Replace with function body.


func _on_sel_button_pressed() -> void:
	if get_node("/root/Global").inTutorial:
		return
	sell_ingredients(current, sellAmount)
	sellAmount = 0
	baseNode.get_node("Sell/SellTextEdit").text = str(buyAmount)
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
		
	global.money = global.money + amount * global.getIngredient(ingredient).price * 0.8
	events.on_money_changed(global.money)
	global.game_state["ingredientsHold"][ingredient] -= amount
	events.on_ingredients_updated()
