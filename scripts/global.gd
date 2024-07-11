extends Node

var f3_enabled: bool = false
var player: CharacterBody2D

func play_sound(clip: AudioStream, pitch, volume):
	var player = AudioStreamPlayer.new()
	get_tree().root.add_child(player)
	player.stream = clip
	player.pitch_scale = pitch
	player.volume_db = volume
	player.play()
	await player.finished
	player.queue_free()
