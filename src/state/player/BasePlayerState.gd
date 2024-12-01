class_name BasePlayerState extends PlayerState

const FIGHTING = "Fighting"
const SERVING = "Serving"
const WALKING = "Walking"
const WALKING3TH = "WalkingFollow"
const IDLEFOLLOW = "IdleFollow"
const IDLE = "Idle"
const IDLEHOLD = "IdleHold"

var player: Player

var logger: Log

var global: GlobalState
var events: EventManager

func _ready() -> void:
	global = get_node("/root/Global")
	logger = get_node("/root/Log")
	events = get_node("/root/Events")
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerBaseState state type must be used only in the player scene. It needs the owner to be a player node.")