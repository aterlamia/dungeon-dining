class_name EventManager

extends Node

signal pauze
signal in_menu
signal game_started
signal scene_done
signal scene_started
signal gameover
signal scene_restarted
signal play_music
signal fps_displayed
signal config_loaded
signal customer_seated
signal cooking_done
signal delivery_pickup
signal delivery_attempt
signal camera_switch
signal recipe_selected
signal ingredients_updated
signal recipe_added(recipe:String, amount:int)
signal diner_opened
signal gold_changed
signal availability_updated
signal ingredient_selected
signal loot_generated(name:String, amount:int)
signal tutorial_switch
signal start_battle(name:String, lvl:int)
signal end_battle
signal damage_player
var log

func _ready() -> void: 
	self.log = get_node("/root/Log")
	pass

func on_tutorial_switch(nr: int)  -> void: 
	self.log.log_info("Switched to tutorial step" + str(nr), log.LogType.LOG_SIGNAL)
	emit_signal("tutorial_switch", nr)

func on_loot_generated(name: String, amount: int)  -> void: 
	self.log.log_info("GeneratedLoot" + name + " - " + str(amount), log.LogType.LOG_SIGNAL)
	emit_signal("loot_generated", name, amount)

func on_damage_player(nr: float)  -> void: 
	self.log.log_info("Player damaged" + str(nr), log.LogType.LOG_SIGNAL)
	emit_signal("damage_player", nr)
	
func on_start_battle(name:String, lvl:int)  -> void: 
	self.log.log_info("Started battle with a " + name + " at lvl " + str(lvl), log.LogType.LOG_SIGNAL)
	emit_signal("start_battle", name, lvl)
	
func on_end_battle()  -> void: 
	self.log.log_info("Ended battle", log.LogType.LOG_SIGNAL)
	emit_signal("end_battle")
	
func on_customer_seated(customer: Npc)  -> void: 
	self.log.log_info("Customer seated" + customer.customerName, log.LogType.LOG_SIGNAL)
	emit_signal("customer_seated", customer)

func on_money_changed(amount: float)  -> void: 
	self.log.log_info("MOney changed" + str(amount), log.LogType.LOG_SIGNAL)
	emit_signal("gold_changed", amount)

func on_delivery_pickup(dish: String)  -> void: 
	self.log.log_info("delivery_pickup " + dish, log.LogType.LOG_SIGNAL)
	emit_signal("delivery_pickup", dish)

func on_cooking_done(order: CustomerOrder)  -> void: 
	self.log.log_info("Meal made" + order.dish, log.LogType.LOG_SIGNAL)
	emit_signal("cooking_done", order)
	
func on_camera_switch(camera: String)  -> void: 
	emit_signal("camera_switch", camera)	
	
func on_recipe_selected(recipe: String)  -> void: 
	emit_signal("recipe_selected", recipe)
	
func on_recipe_added(recipe: String, amount:int)  -> void: 
	self.log.log_info("Recipe added" + recipe + "(" + str(amount) + ")", log.LogType.LOG_SIGNAL)
	recipe_added.emit(recipe, amount)

func on_availability_updated()  -> void: 
	self.log.log_info("Availability of dishes was updated", log.LogType.LOG_SIGNAL)
	availability_updated.emit()
	
func on_ingredients_updated()  -> void: 
	ingredients_updated.emit()
	
func on_ingredient_selected(ingredient: String)  -> void: 
	self.log.log_info("Ingredient selected" + ingredient, log.LogType.LOG_SIGNAL)
	emit_signal("ingredient_selected", ingredient)
	
func on_deliver_attempt(order)  -> void: 
	self.log.log_info("PLayer trying to offer " + order.dish, log.LogType.LOG_SIGNAL)
	emit_signal("delivery_attempt", order)

func on_game_started(state: bool)  -> void: 
	self.log.log_info("Started " + ("True" if state else "False"), log.LogType.LOG_SIGNAL)
	emit_signal("game_started", state)

func on_pauze(state: bool)  -> void: 
	self.log.log_info("Pauze " + ("True" if state else "False"), log.LogType.LOG_SIGNAL)
	emit_signal("pauze", state)

func on_in_menu(state: bool)  -> void: 
	self.log.log_info("in Menu " + ("True" if state else "False"), log.LogType.LOG_SIGNAL)
	emit_signal("in_menu", state)

func on_diner_opened(open: bool)  -> void: 
	self.log.log_info("Diner opened " + ("True" if open else "False"), log.LogType.LOG_SIGNAL)
	emit_signal("diner_opened", open)
	
func on_config_loaded()  -> void: 
	self.log.log_info("Config loaded", log.LogType.LOG_SIGNAL)
	emit_signal("config_loaded")

func on_fps_displayed(state: bool)  -> void: 
	self.log.log_info("Showfps " + ("True" if state else "False"), log.LogType.LOG_SIGNAL)
	emit_signal("fps_displayed", state)

func on_play_music(name: String) -> void: 
	self.log.log_info("play_music: " + name, log.LogType.LOG_SIGNAL)
	emit_signal("play_music", name)

func on_scene_done(scene: int) -> void: 
	self.log.log_info("Scene done: " + str(scene), log.LogType.LOG_SIGNAL)
	emit_signal("scene_done", scene)

func on_scene_started(scene: int) -> void: 
	self.log.log_info("Scene started: " + str(scene), log.LogType.LOG_SIGNAL)
	emit_signal("scene_started", scene)

func on_scene_restarted(scene: int) -> void: 
	self.log.log_info("Scene restarted: " + str(scene), log.LogType.LOG_SIGNAL)
	emit_signal("scene_restarted", scene)

func on_gameover(scene: int) -> void: 
	self.log.log_info("Gameover: " + str(scene), log.LogType.LOG_SIGNAL)
	emit_signal("gameover", scene)
