class_name GameDialog

extends CanvasLayer
@export_enum("Tutorial", "StoryCeller") var what_dialog: String

signal dialog_done(what_dialog: String, currentPos: int)

var currentPos = 0
var dialogOptions: Array = [
	{
		"who": "chef",
		"text": "Oh no you know who that is right?"
	},
	{
		"who": "you",
		"text": "He looks familiar but I can't place him, he looks fancy though."
	},
	{
		"who": "chef",
		"text": "Thats the famous restaurant critic Edward von Edwardson, he's can make or break a restaurant with a single review."
	},
	{
		"who": "you",
		"text": "Oh no why now, we just opened, we can't afford a bad review. We have so much to improve."
	},
	{
		"who": "chef",
		"text": "I got more bad news, the kitchen is out of ingredients, we can't cook anything. And the coffee is not going to be enough to impress him."
	},
	{
		"who": "chef",
		"text": "To be honest the coffee is quite bad, I don't think he will be impressed."
	},	
	{
		"who": "you",
		"text": "What can we do? i Don't want to lose the restaurant now i just got started."
	},
	{
		"who": "Edward von Edwardson",
		"text": "\"Writing someting on a notepad\" Auhum i am waiting for you to take my order."
	},
	{
		"who": "you",
		"text": "Oh on! oh no!"
	},
	{
		"who": "you",
		"text": "What can i get you sir?"
	},
	{
		"who": "Edward von Edwardson",
		"text": "\"Writing more on the notepad\" As you might know you are not the first exlpoiter of this place, and i have to say so i am not impressed."
	},
	{
		"who": "Edward von Edwardson",
		"text": "The place looks barerly functional, and frankly it looks like a mess here"
	},
	{
		"who": "Edward von Edwardson",
		"text": "I actually started my career here, and it was the best experience of my life, the burger was the best i ever had, and the coffee was amazing."
	},
	{
		"who": "Edward von Edwardson",
		"text": "i asked them what they do with the burger to make it so good, they never told me and said it was a secret ingredient"
	},
	{
		"who": "Edward von Edwardson",
		"text": "That being said, i will start with a coffee while i am waiting for a burger, dont dissapoint me. I dont want my memory of this place turn sour."
	},
	{
		"who": "you",
		"text": "\"Whispering to the chef\"  i will be ruined no stores are open, we have no ingredients, and the coffee is bad."
	},
	{
		"who": "chef",
		"text": "Go to the cellar, there might some ingredients left, all we need is some greens we still have bread and a patty, I will try to make the best coffee i ever made."
	},
	{
			"who": "chef",
			"text": "In case you forgot you can access the cellar from the kitchen."
	}
]

var dialogOptionsCellar: Array = [
	{
		"who": "you",
		"text": "Lets look around, maybe i can find some greens."
	},
	{
		"who": "you",
		"text": "Nothing here!"
	},
	{
		"who": "you",
		"text": "WHA !!!!!"
	},
]


func _ready():
	switch(0)
	pass
	
func getLastDialog() -> int:
	match what_dialog:
		"StoryCeller":
			return 3
		"Tutorial":
			return 17
		_:
			return 0
	return currentPos
	
# when the dialog key is pressed also go to nect dialog
func _input(event: InputEvent) -> void:
	if visible && event.is_action_pressed("dialog"):
		doSwitch()
	pass
	
func switch(pos: int):
	var activeDialog = null
	
	match what_dialog:
		"StoryCeller":
			activeDialog = dialogOptionsCellar
		"Tutorial":
			activeDialog = dialogOptions
		_:
			activeDialog = dialogOptions
	
	
	currentPos = pos
	var dialogText = get_node("DialogPanel/DialogText")
	var dialogYou = get_node("DialogPanel/You")
	var dialogNotYou: TextureRect = get_node("DialogPanel/NotYou")
	var NameYou = get_node("DialogPanel/NameYou")
	var NameNotYou = get_node("DialogPanel/NameNotYou")
	
	dialogText.text = activeDialog[pos]["text"]
	
	if(activeDialog[pos]["who"] != "you"):
		dialogYou.visible = false
		dialogNotYou.visible = true
		NameYou.visible = false
		NameNotYou.visible = true
		if(activeDialog[pos]["who"] != "chef"):
			dialogNotYou.texture = load("res://assets/story/rec.png")
		else:
			dialogNotYou.texture = load("res://assets/story/chef.png")
			
		NameNotYou.text = activeDialog[pos]["who"]
	else:
		dialogYou.visible = true
		dialogNotYou.visible = false
		NameYou.text = activeDialog[pos]["who"]
		NameYou.visible = true
		NameNotYou.visible = false

	print("switching to: " + str(pos))
	if(pos == 17):
		get_node("/root/Events").on_in_menu(false)
	pass
	
	
func doSwitch():
	print(what_dialog, currentPos)
	dialog_done.emit(what_dialog, currentPos)
	if(what_dialog == "StoryCeller"):
		if(currentPos == 2):
			visible = false
			get_node("/root/Events").on_in_menu(true)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			return
		visible = false
		get_node("/root/Events").on_in_menu(false)
		return
	if(currentPos < getLastDialog()):
		switch(currentPos + 1)
	else:
		visible = false
	pass
func _on_button_pressed() -> void:
	doSwitch()
	pass
