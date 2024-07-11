extends Node

var f3_enabled: bool = false
var player: CharacterBody2D

var ambience: AudioStream = preload("res://assets/sounds/ocean.wav")

func _ready():
	await get_tree().process_frame
	play_ambience()

func play_ambience():
	print("Playing ambience")
	await play_sound(ambience,1.0,0)
	play_ambience()

func play_sound(clip: AudioStream, pitch, volume):
	var player = AudioStreamPlayer.new()
	get_tree().root.add_child(player)
	player.stream = clip
	player.pitch_scale = pitch
	player.volume_db = volume
	player.play()
	await player.finished
	player.queue_free()
