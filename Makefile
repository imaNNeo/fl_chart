checkstyle:
	flutter analyze; \
	flutter format --set-exit-if-changed --dry-run --line-length 100 .

format:
	flutter format --line-length 100 .

runTests:
	flutter test

checkoutToPR:
	git fetch origin pull/$(id)/head:pr-$(id); \
	git checkout pr-$(id)

# Tells you in which version this commit has landed
findVersion:
	git describe --contains $(commit) | sed 's/~.*//'

# Runs both `make runTests` and `make checkstyle`. Use this before pushing your code.
sure:
	make runTests && make checkstyle
