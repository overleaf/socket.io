
ALL_TESTS = $(shell find test/ -name '*.test.js')
ALL_BENCH = $(shell find benchmarks -name '*.bench.js')

run-tests:
	@./node_modules/.bin/expresso \
		-t 3000 \
		-I support \
		--serial \
		$(TESTFLAGS) \
		$(TESTS)

test:
	@$(MAKE) NODE_PATH=lib TESTS="$(ALL_TESTS)" run-tests

test-cov:
	@TESTFLAGS=--cov $(MAKE) test

test-leaks:
	@ls test/leaks/* | xargs node --expose_debug_as=debug --expose_gc

run-bench:
	@node $(PROFILEFLAGS) benchmarks/runner.js

bench:
	@$(MAKE) BENCHMARKS="$(ALL_BENCH)" run-bench

profile:
	@PROFILEFLAGS='--prof --trace-opt --trace-bailout --trace-deopt' $(MAKE) bench

.PHONY: test bench profile

ol_init:
	docker run \
		--rm \
		-v ${PWD}:/app \
		-w /app \
		node:0.12 npm i

ol_run:
	docker run \
 		--rm \
 		-v ${PWD}:/app \
 		-w /app \
 		-e NODE_TLS_REJECT_UNAUTHORIZED=0 \
 		node:0.12 make test
