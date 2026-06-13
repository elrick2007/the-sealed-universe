extends AudioStreamPlayer

@export var volume := -18.0
@export var base_frequency := 43.0

var playback: AudioStreamGeneratorPlayback
var phase_a := 0.0
var phase_b := 0.0
var sample_rate := 22050.0

func _ready() -> void:
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = sample_rate
	generator.buffer_length = 0.5
	stream = generator
	volume_db = volume
	play()
	playback = get_stream_playback()

func _process(_delta: float) -> void:
	if playback == null:
		return
	var frames := playback.get_frames_available()
	for i in frames:
		var wave := sin(phase_a) * 0.09 + sin(phase_b) * 0.035
		var pulse := sin(Time.get_ticks_msec() * 0.0017) * 0.025
		var sample := wave + pulse
		playback.push_frame(Vector2(sample, sample))
		phase_a = fmod(phase_a + TAU * base_frequency / sample_rate, TAU)
		phase_b = fmod(phase_b + TAU * (base_frequency * 1.51) / sample_rate, TAU)
