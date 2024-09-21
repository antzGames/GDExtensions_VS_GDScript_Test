extends CenterContainer

@onready var gd_example: GDExample = $GDExample
var average: float = 0.0
var total_time: float = 0.0
var iteration: int = 0
var platform: String

const MAX_NUMBER: int = 2000000
@onready var info_label: Label = $VBoxContainer/Info
@onready var result_label: Label = $VBoxContainer/Result

# Called when the node enters the scene tree for the first time.
func _ready():
	# Change the target platform here
	
	#platform = "GDScript"
	platform = "C++"
	
	platform += str(" ", OS.get_name())

func _process(_delta: float) -> void:
	var result: int
	iteration += 1
	info_label.text = str("Platform: ", platform, "    Iteration: ", iteration, "    Average: %.2f" % average, "ms")
	
	# Start timer
	var time_start: float = Time.get_unix_time_from_system()
	
	if platform.begins_with("C++"):
		gd_example.do_primes()
		result = gd_example.get_primes()
	else:
		result = SieveOfEratosthenes(MAX_NUMBER)
	
	var time_end: float = Time.get_unix_time_from_system()
	var time: float = (time_end - time_start) * 1000.0
	total_time += time
	average = total_time / iteration
	result_label.text = str(result, " prime numbers found between 0 and ", MAX_NUMBER, ".  Took: %.0f" % time, "ms")

func SieveOfEratosthenes(n: int) -> int:
	var numberOfPrimes = 0
	var prime = Array()
	prime.resize(n+1)
	prime.fill(true)
	
	var p: int = 2
	while (p * p <= n):
		if (prime[p]):
			for i in range(p * p, n+1, p):
				prime[i] = false
		p += 1
		
	for pp in range(2, n+1):
		if prime[pp]:
			numberOfPrimes += 1
			
	return numberOfPrimes
