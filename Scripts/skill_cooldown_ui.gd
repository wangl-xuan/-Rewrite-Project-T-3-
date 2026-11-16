extends CanvasLayer

@onready var rewind = get_node_or_null("../Player/Rewind")
@onready var phase = get_node_or_null("../Player/Phase")

@onready var rewind_label: Label = $Panel/RewindLabel
@onready var rewind_cooldown_bar: ProgressBar = $Panel/RewindCooldownBar

@onready var phase_label: Label = $Panel2/PhaseLabel
@onready var phase_cooldown_bar: ProgressBar = $Panel2/PhaseCooldownBar


func _process(_delta: float) -> void:
	var rewind_cooldown = rewind.get("cooldown")
	var rewind_elapsed = rewind.get("time_since_rewind")
	
	var rewind_remaining = maxf(rewind_cooldown-rewind_elapsed, 0.0)
	
	#cooldown text
	if rewind_remaining <= 0:
		rewind_label.text = "READY"
	else:
		rewind_label.text = "%.1f s" % rewind_remaining
	
	#progress bar
	if rewind_cooldown > 0:
		var progress = rewind_elapsed / rewind_cooldown
		progress = clampf(progress, 0.0, 1.0)
		rewind_cooldown_bar.value = progress * 100
	
	else:
		rewind_cooldown_bar.value = 100
	
	#phase cooldown
	var phase_time = phase.get("phase_time")
	var phase_cooldown = phase.get("cooldown_time")
	var phase_elapsed = phase.get("time_since_phase")
	
	#phase is active
	if phase_elapsed <= phase_time:
		phase_cooldown_bar.modulate = Color.GREEN_YELLOW
		
		var phase_remaining = phase_time - phase_elapsed
		
		phase_label.text = "%.1f s" % phase_remaining
		
		if phase_time > 0:
			phase_cooldown_bar.value = (phase_elapsed / phase_time) * 100
		else:
			phase_cooldown_bar.value = 100
		
	else:
		#phase has ended, start cooldow
		phase_cooldown_bar.modulate = Color.WHITE
		
		var cooldown_elapsed = phase_elapsed - phase_time
		var cooldown_remaining = phase_cooldown - cooldown_elapsed
		
		if cooldown_remaining <= 0:
			phase_label.text = "READY"
			phase_cooldown_bar.value = 100
		else:
			phase_label.text = "%.1f s" % cooldown_remaining
		
		if phase_cooldown > 0:
			phase_cooldown_bar.value = (cooldown_elapsed / phase_cooldown) * 100
		else:
			phase_cooldown_bar.value = 100
