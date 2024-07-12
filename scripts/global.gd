extends Node

var f3_enabled: bool = false
var player: CharacterBody2D

var time: float = 8.0 # Military Time

var ambience: AudioStream = preload("res://assets/sounds/ocean.wav")

func play_sound(clip: AudioStream, pitch, volume):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = clip
	player.pitch_scale = pitch
	player.volume_db = volume
	player.play()
	await player.finished
	player.queue_free()

func _process(delta):
	time += delta / 30
	if(time >= 24):
		time = 0
