// Performance Benchmark: Goroutine Ping-Pong
// Baseline for comparison with MVL actors

package main

import (
	"fmt"
	"time"
)

func main() {
	iterations := 1_000_000

	pingChan := make(chan struct{})
	pongChan := make(chan struct{})
	done := make(chan struct{})

	// Pong goroutine: receives ping, sends pong
	go func() {
		for i := 0; i < iterations; i++ {
			<-pingChan
			pongChan <- struct{}{}
		}
	}()

	// Ping goroutine: sends ping, waits for pong
	go func() {
		for i := 0; i < iterations; i++ {
			pingChan <- struct{}{}
			<-pongChan
		}
		close(done)
	}()

	start := time.Now()

	// Wait for completion
	<-done

	elapsed := time.Since(start)
	throughput := float64(iterations*2) / elapsed.Seconds()

	fmt.Printf("Ping-Pong Benchmark\n")
	fmt.Printf("Iterations: %d round-trips\n", iterations)
	fmt.Printf("Time: %v\n", elapsed)
	fmt.Printf("Throughput: %.2f msgs/sec\n", throughput)
	fmt.Printf("Latency: %.2f ns/round-trip\n", float64(elapsed.Nanoseconds())/float64(iterations))
}
