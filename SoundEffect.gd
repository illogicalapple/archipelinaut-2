extends Resource
class_name SoundEffect

@export var clips: Array[AudioStream]

@export var default_volume: float = 0.0
@export var volume_variation: float = 0.0
@export var default_pitch: float = 1.0
@export var pitch_variation: float = 0.2

func play():
	var clip = clips.pick_random()
	assert(clip)
	if(clip):
		Global.play_sound(clip,default_pitch + randf_range(-pitch_variation,pitch_variation), default_volume + randf_range(-volume_variation,volume_variation))
