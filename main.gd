extends Node2D 

# Fishing states
enum FishingState { IDLE, CASTING, WAITING, REELING }
var fishing_state = FishingState.IDLE

var wait_time = 0.0
var bite_chance = 0.5  # 50% chance to bite

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	match fishing_state:
		FishingState.WAITING:
			$AnimatedSprite2D.play("waiting")
			wait_time -= delta
			if wait_time <= 0:
				if randf() < bite_chance:
					$MessageLabel.text = "A fish is biting! Reel it in!"
					fishing_state = FishingState.REELING
				else:
					$MessageLabel.text = "Nothing bit this time."
					fishing_state = FishingState.IDLE

		FishingState.REELING:
			$AnimatedSprite2D.play("reeling")

		_:
			$AnimatedSprite2D.stop()  # for idle / casting

func _on_texture_button_pressed() -> void:
	match fishing_state:
		FishingState.IDLE:
			$MessageLabel.text = "You cast your line!"
			fishing_state = FishingState.WAITING
			wait_time = randf_range(2.0, 5.0)

		FishingState.REELING:
			$MessageLabel.text = "You caught a fish!"
			fishing_state = FishingState.IDLE

		FishingState.WAITING:
			$MessageLabel.text = "Patience... a fish might bite soon."

		FishingState.CASTING:
			$MessageLabel.text = "You already casted your line!"
