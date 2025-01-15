analyze:
	flutter analyze

checkFormat:
	dart format -o none --set-exit-if-changed .

checkstyle:
	make analyze && make checkFormat

format:
	dart format .

runTests:
	flutter test

checkoutToPR:
	git fetch origin pull/$(id)/head:pr-$(id) --force; \
	git checkout pr-$(id)

# Tells you in which version this commit has landed
findVersion:
	git describe --contains $(commit) | sed 's/~.*//'

# Runs both `make runTests` and `make checkstyle`. Use this before pushing your code.
sure:
	make runTests && make checkstyle

# To create generated files (for example mock files in unit_tests)
codeGen:
	dart run build_runner build --delete-conflicting-outputs

showTestCoverage:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	source ./scripts/makefile_scripts.sh && open_link "coverage/html/index.html"

buildRunner:
	flutter packages pub run build_runner build --delete-conflicting-outputs
