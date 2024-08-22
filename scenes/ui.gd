extends Control

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		Engine.max_fps = 2
		$UnfocusedNotifier.show()
	elif what == NOTIFICATION_APPLICATION_FOCUS_IN:
		Engine.max_fps = 0
		$UnfocusedNotifier.hide()
