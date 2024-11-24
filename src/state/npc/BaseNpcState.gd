class_name BaseNpcState extends NpcState

const ENTERING = "Entering"
const SEATING = "Seating"
const WALKING = "Walking"
const ORDERING = "Ordering"
const IDLE = "Idle"
const EATING = "Eating"

var npc: Npc

var logger: Log

var global: GlobalState
var events: EventManager

func _ready() -> void:
	global = get_node("/root/Global")
	logger = get_node("/root/Log")
	events = get_node("/root/Events")
	await owner.ready
	npc = owner as Npc
	assert(npc != null, "The NpcBaseState state type must be used only in the npc scene. It needs the owner to be a npc node.")