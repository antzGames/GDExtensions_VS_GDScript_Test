extends CenterContainer

# time variables
var average: float = 0.0
var averageSegmented: float = 0.0
var total_time: float = 0.0

# label results and text variables
var iteration: int = 0
var platform: String
var result: int
var numberOfPrimes: int = 0
var primes : Array[int]

# Set range of prime number search 0..MAX_NUMBER
const MAX_NUMBER: int = 20000000

# lable nodes
@onready var info_label: Label = $VBoxContainer/Info
@onready var result_label: Label = $VBoxContainer/Result
@onready var algo: Label = $VBoxContainer/Algo
@onready var gd_example: GDExample = $GDExample # this is the C++ GDExtension

# Called when the node enters the scene tree for the first time.
func _ready():
	# Change the target platform here
	
	#platform = "GDScript"
	platform = "C++"
	
	platform += str(" on ", OS.get_name())
	algo.text = str("Time Complexity : O(n * ln(sqrt(n)))     Auxiliary Space: O(sqrt(n)))");

func clean_up():
	numberOfPrimes = 0
	primes.clear()
	result = 0

func _process(_delta: float) -> void:
	clean_up()
	
	# update iteration label text
	iteration += 1
	info_label.text = str("Platform: ", platform, "    Iteration: ", iteration, "\n\n")
	
	# Start timer
	var time_start: float = Time.get_unix_time_from_system()
	
	# runs algorithm on correct platform
	if platform.begins_with("C++"):
		gd_example.do_primes(MAX_NUMBER)
		result = gd_example.get_primes()
	else:
		result = SegmentedSieve(MAX_NUMBER)
	
	# stop timer, calc total time, calc average time and update label text
	var time_end: float = Time.get_unix_time_from_system()
	var time: float = (time_end - time_start) * 1000.0
	total_time += time
	average = total_time / iteration
	result_label.text = str("Segmented Sieve Of Eratosthenes: ", "   Average: %.2f" % average, "ms\n",result, " prime numbers found between 0 and ", MAX_NUMBER, ".  Took: %.0f" % time, "ms")


func SimpleSieve(limit: int):
	var mark : Array[bool]
	mark.resize(limit + 1)
	mark.fill(true)
	
	var p: int = 2
	while (p * p <= limit):
		if (mark[p]):
			for i in range(p * p, limit + 1, p):
				mark[i] = false
		p += 1
		
	for pp in range(2, limit):
		if mark[pp]:
			numberOfPrimes += 1
			primes.append(pp)

func SegmentedSieve(n: int) -> int:
	var limit: int = int(floori(sqrt(n)) + 1)
	SimpleSieve(limit)
	
	var low: int = limit
	var high: int = limit * 2
	var mark: Array[bool]
	mark.resize(limit+1)
	
	while low < n:
		if high >= n:
			high = n
	
		mark.fill(true)
	
		for i in range(primes.size()):
			var loLim: int = int(floori(low / primes[i]) * primes[i])
			
			if loLim < low:
				loLim += primes[i]
			
			for j in range(loLim, high, primes[i]):
				mark[j - low] = false
		
		for i in range(low, high):
			if mark[i - low]:
				numberOfPrimes += 1
		
		low = low + limit
		high = high + limit
	
	return numberOfPrimes
