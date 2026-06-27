# Performance Benchmarks

Measure MVL's runtime performance against equivalent implementations in other languages.

## Focus Areas

### 1. Actor Concurrency (`actors/`)

Benchmark MVL's actor runtime (work-stealing scheduler, crossbeam channels) against:
- Go goroutines + channels
- Rust async/await + tokio
- Erlang/BEAM processes

**Metrics:**
- Message throughput (msgs/sec)
- Latency (p50, p99)
- Memory per actor
- Scaling with core count

### 2. String Processing (`strings/`)

Benchmark MVL's string handling against C, Rust, Go:
- Parsing (JSON, CSV, log lines)
- Compression (bzip2-style algorithms)
- Pattern matching

**Metrics:**
- Throughput (MB/sec)
- Memory allocation
- Safety overhead (bounds checks)

## Structure

```
performance/
├── actors/
│   ├── ping_pong/          # Basic message passing
│   ├── ring/               # N actors in ring topology
│   └── fanout/             # 1-to-N message distribution
├── strings/
│   ├── json_parse/         # Parse JSON documents
│   ├── csv_transform/      # CSV processing
│   └── compress/           # Compression algorithms
└── results/
    └── YYYY-MM-DD/         # Benchmark results by date
```

## Running

```bash
# From benchmark root
make test-perf

# Individual benchmarks
cd performance/actors/ping_pong && make bench
cd performance/strings/json_parse && make bench
```

## Baseline Targets

| Benchmark | Target vs Rust | Notes |
|-----------|----------------|-------|
| Actor ping-pong | <2x overhead | Safety checks cost |
| Ring throughput | ~1x | Work-stealing should match |
| JSON parse | <1.5x overhead | Bounds checks |
| Compression | <1.2x overhead | Tight loops |

## Current Benchmarks

| Category | Benchmark | Status |
|----------|-----------|--------|
| Actors | ping_pong | ✅ |
| Actors | ring | ✅ |
| Strings | json_parse | TODO |
| Strings | compress | TODO |
