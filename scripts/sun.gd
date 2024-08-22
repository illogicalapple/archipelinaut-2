extends DirectionalLight2D

@export var brightness: Curve
@export var gradient: Gradient

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var t = Global.time / 24
	color = gradient.sample(t)
	energy = brightness.sample(t)
