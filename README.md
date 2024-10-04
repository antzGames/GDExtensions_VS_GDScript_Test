# GDExtensions_VS_GDScript_Test
 C++ vs. GDScript Prime Number Test

This is a prime number test using this algorithm: https://www.geeksforgeeks.org/segmented-sieve/

Keep in mind this is the worst possible test for GDScipt and the best possible for C++.

This video on Youtube explains everything better: [https://youtu.be/qDXomV7Ojko
](https://youtu.be/c9gRhi-Aucw)

Tested using Godot 4.3 stable.  GDExtention shared library only created for Windows and Web.

Both C# and Java projects not included in this repo, but code snippets are below:

## Where is the C# code?

```C#
using Godot;
using System;
using System.Collections.Generic;

public partial class prime : Node {
	
	static int result = 0;

	private void simpleSieve(int limit, HashSet<int> prime) {
		bool[] mark = new bool[limit + 1];
		
		for (int i = 0; i < mark.Length; i++)
			mark[i] = true;
	
		for (int p = 2; p * p < limit; p++) {
			// If p is not changed, then it is a prime
			if (mark[p]) {
				// Update all multiples of p
				for (int i = p * p; i < limit; i += p)
					mark[i] = false;
			}
		}
	
		// Print all prime numbers and store them in prime
		for (int p = 2; p < limit; p++) {
			if (mark[p]) {
				prime.Add(p);
				result++;
			}
		}
	}
	
	public int SegmentedSieve(int n) {
		result = 0;
		int limit = (int) (Math.Floor(Math.Sqrt(n)) + 1);
		HashSet<int> prime = new HashSet<int>(); 
		simpleSieve(limit, prime); 
	
		int low = limit;
		int high = 2*limit;

		while (low < n) {
			if (high >= n) 
				high = n;

			bool[] mark = new bool[limit + 1];
			
			for (int i = 0; i < mark.Length; i++)
				mark[i] = true;
	
			foreach (int i in prime) {
				int loLim = ((int)Math.Floor((double)(low / i)) * i);
				if (loLim < low)
					loLim += i;
   
				for (int j = loLim; j < high; j += i)
					mark[j-low] = false;
			}
	
			// Numbers which are not marked as false are prime
			for (int i = low; i < high; i++)
				if (mark[i - low])
					result++;
	
			// Update low and high for next segment
			low = low + limit;
			high = high + limit;
		}
		return result;
	}
}
```

# Where is the Java code?

```java
package godot;

import godot.annotation.Export;
import godot.annotation.RegisterClass;
import godot.annotation.RegisterFunction;
import godot.annotation.RegisterProperty;

import java.util.ArrayList;
import static java.lang.Math.sqrt;
import static java.lang.Math.floor;

@RegisterClass
public class PrintTextJava extends Label {
	@Export
	@RegisterProperty
	public int test = 0;

	public static final int MAX_NUMBER = 20000000;
	public int NUMBER_OF_PRIME_NUMBERS = 0;
	public int iterationNumber;
	public double timeStart, timeEnd, iterationTime, totalTime, average;

	@RegisterFunction
	@Override
	public void _ready() {

	}

	@RegisterFunction
	@Override
	public void _process(double delta) {
		iterationNumber++;

		// Time the test
		timeStart = Time.INSTANCE.getUnixTimeFromSystem();
		segmentedSieve(MAX_NUMBER);
		timeEnd = Time.INSTANCE.getUnixTimeFromSystem();

		iterationTime = (timeEnd - timeStart) * 1000.0;
		totalTime += iterationTime;

		average = totalTime / iterationNumber;

		setText("Platform: Java/Kotlin Desktop   Iterations: " + iterationNumber +
				"    Average: " + String.format("%.2f", average) +"ms\n" +  NUMBER_OF_PRIME_NUMBERS +
				" prime numbers found between 0 and " + MAX_NUMBER + ".  Took: " + String.format("%.2f", iterationTime) + "ms");
	}

	private void simpleSieve(int limit, ArrayList<Integer> prime){

		boolean mark[] = new boolean[limit+1];

		for (int i = 0; i < mark.length; i++)
			mark[i] = true;

		for (int p=2; p*p<limit; p++) {
			// If p is not changed, then it is a prime
			if (mark[p]) {
				// Update all multiples of p
				for (int i=p*p; i<limit; i+=p)
					mark[i] = false;
			}
		}

		// Print all prime numbers and store them in prime
		for (int p=2; p<limit; p++)
		{
			if (mark[p]) {
				prime.add(p);
				NUMBER_OF_PRIME_NUMBERS++;
			}
		}
	}

	// Prints all prime numbers smaller than 'n'
	private void segmentedSieve(int n) {
		NUMBER_OF_PRIME_NUMBERS = 0;
		// Compute all primes smaller than or equal
		// to square root of n using simple sieve
		int limit = (int) (floor(sqrt(n))+1);
		ArrayList<Integer> prime = new ArrayList<>();
		simpleSieve(limit, prime);

		// Divide the range [0..n-1] in different segments
		// We have chosen segment size as sqrt(n).
		int low  = limit;
		int high = 2*limit;

		// While all segments of range [0..n-1] are not processed,
		// process one segment at a time
		while (low < n)	{
			if (high >= n)
				high = n;

			// To mark primes in current range. A value in mark[i]
			// will finally be false if 'i-low' is Not a prime,
			// else true.
			boolean mark[] = new boolean[limit+1];

			for (int i = 0; i < mark.length; i++)
				mark[i] = true;

			// Use the found primes by simpleSieve() to find
			// primes in current range
			for (int i = 0; i < prime.size(); i++) {
				// Find the minimum number in [low..high] that is
				// a multiple of prime.get(i) (divisible by prime.get(i))
				// For example, if low is 31 and prime.get(i) is 3,
				// we start with 33.
				int loLim = (int) (floor(low/prime.get(i)) * prime.get(i));
				if (loLim < low)
					loLim += prime.get(i);

                /*  Mark multiples of prime.get(i) in [low..high]:
                    We are marking j - low for j, i.e. each number
                    in range [low, high] is mapped to [0, high-low]
                    so if range is [50, 100]  marking 50 corresponds
                    to marking 0, marking 51 corresponds to 1 and
                    so on. In this way we need to allocate space only
                    for range  */
				for (int j=loLim; j<high; j+=prime.get(i))
					mark[j-low] = false;
			}

			// Numbers which are not marked as false are prime
			for (int i = low; i<high; i++) {
				if (mark[i - low])	NUMBER_OF_PRIME_NUMBERS++;
			}

			// Update low and high for next segment
			low  = low + limit;
			high = high + limit;
		}
	}
}
```
