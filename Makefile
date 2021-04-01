checkstyle:
	flutter analyze; \
	flutter format --set-exit-if-changed --dry-run --line-length 100 .

format:
	flutter format --line-length 100 .

runTests:
	flutter test
