// Performance Benchmark: Goroutine Ping-Pong
// Baseline for comparison with MVL actors

package main

import (
	"fmt"
	"time"
)

func ping(pingChan, pongChan chan int, iterations int) {
	for i := 0; i < iterations; i++ {
		pingChan <- i
		<-pongChan
	}
	close(pingChan)
}

func pong(pingChan, pongChan chan int) {
	for range pingChan {
		pongChan <- 1
	}
	close(pongChan)
}

func main() {
	iterations := 1_000_000

	pingChan := make(chan int)
	pongChan := make(chan int)

	start := time.Now()

	go pong(pingChan, pongChan)
	go ping(pingChan, pongChan, iterations)

	// Wait for completion
	for range pongChan {
	}

	elapsed := time.Since(start)
	throughput := float64(iterations*2) / elapsed.Seconds()

	fmt.Printf("Iterations: %d\n", iterations)
	fmt.Printf("Time: %v\n", elapsed)
	fmt.Printf("Throughput: %.2f msgs/sec\n", throughput)
	fmt.Printf("Latency: %.2f ns/msg\n", float64(elapsed.Nanoseconds())/float64(iterations*2))
}
