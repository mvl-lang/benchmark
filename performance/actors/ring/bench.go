// Performance Benchmark: Goroutine Ring
// N goroutines in a ring, passing a token M times

package main

import (
	"fmt"
	"time"
)

func ringNode(id int, in <-chan int, out chan<- int, done chan<- bool) {
	for token := range in {
		if token > 0 {
			out <- token - 1
		} else {
			done <- true
			return
		}
	}
}

func main() {
	ringSize := 100
	tokenHops := 1_000_000

	// Create channels
	channels := make([]chan int, ringSize)
	for i := range channels {
		channels[i] = make(chan int, 1)
	}
	done := make(chan bool)

	start := time.Now()

	// Spawn ring nodes
	for i := 0; i < ringSize; i++ {
		next := (i + 1) % ringSize
		go ringNode(i, channels[i], channels[next], done)
	}

	// Inject token
	channels[0] <- tokenHops

	// Wait for completion
	<-done

	elapsed := time.Since(start)
	throughput := float64(tokenHops) / elapsed.Seconds()

	fmt.Printf("Ring size: %d\n", ringSize)
	fmt.Printf("Token hops: %d\n", tokenHops)
	fmt.Printf("Time: %v\n", elapsed)
	fmt.Printf("Throughput: %.2f msgs/sec\n", throughput)
	fmt.Printf("Latency: %.2f ns/hop\n", float64(elapsed.Nanoseconds())/float64(tokenHops))
}
