class_name Recipe

var name: String
var subtitle: String
var level: int
var model: String
var quality_multiplier: float
var cost: float
var type: String
var group: String
var ingredients: Dictionary
var makes: int

func _ready() -> void:
    update_recipe()

func update_recipe() -> void:
    print("Name: %s" % name)
    print("Subtitle: %s" % subtitle)
    print("Quality Multiplier: %.2f" % quality_multiplier)
    print("Cost: %.2f" % cost)
    print("Type: %s" % type)

static func create_recipe(name: String, subtitle: String, level: int, model: String, quality_multiplier: float, cost: float, type: String, makes: int, group: String, ingredients: Dictionary) -> Recipe:
    var recipe = Recipe.new()
    recipe.name = name
    recipe.subtitle = subtitle
    recipe.level = level
    recipe.model = model
    recipe.quality_multiplier = quality_multiplier
    recipe.cost = cost
    recipe.type = type
    recipe.makes = makes
    recipe.ingredients = ingredients
    recipe.group = group
    return recipe