analyze:
	flutter analyze

checkFormat:
	flutter format --set-exit-if-changed --dry-run .

checkstyle:
	make anaylze && make checkFormat

format:
	flutter format .

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

# To create generated files (for example mock files in unit_tests)
codeGen:
	flutter pub run build_runner build
