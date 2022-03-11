# Contributing
Hello, we are glad to have a contributor like you here.  

Don't forget that `open-source` makes no sense without contributors. No matter how big your changes are, it helps us a lot even it is a line of change.

This file is intended to be a guide for those who are interested in contributing to the FL Chart.

#### Below are the people who has contributed to the FL Chart. We hope we have your picture here soon.
[![](https://opencollective.com/fl_chart/contributors.svg?width=890&button=false)](https://github.com/imaNNeoFighT/fl_chart/graphs/contributors)

## Let's get Started

Make sure you have Flutter installed and on your path (follow [installation guide](https://docs.flutter.dev/get-started/install)).

Follow these steps to clone FL Chart and set up the development environment:

1. Fork the repository

2. Clone the project, you can find it in your repositories: `git clone https://github.com/your-username/fl_chart.git`

3. Go into the cloned directory: `cd fl_chart`

4. Install all packages: `flutter packages get`

5. Try to run the sample app. It should work on all platforms (Android, iOS, Web, Linux, MacOS, Windows)

## Before Modifying the Code

If the work you intend to do is non-trivial, it is necessary to open
an issue before starting writing your code. This helps us and the
community to discuss the issue and choose what is deemed to be the
best solution.

### Mention the related issues:
If you are going to fix or improve something, please find and mention the related issues in [CHANGELOG.md](#changelog), commit message and Pull Request description.
In case you couldn't find any issue, it's better to create an issue to explain what's the issue that you are going to fix.

## Let's start by our drawing architecture
We have a *_chart_painter.dart class per each chart type. It draws elements into the Canvas.
We made the CanvasWrapper class, because we wanted to test draw functions.
CanvasWrapper class holds a canvas and all draw functions proxies through it.
You should use it for drawing on the canvas, Instead of direct accessing to canvas.
It makes draw functions testable.

<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/architecture/fl_chart_architecture.jpg" />

(made with [draw.io](https://drive.google.com/file/d/1bj-2TqTRUh80dRKJk10drPNeA3fp3EA8/view))

## Checking Your Code's Quality

After you have made your changes, you have to make sure your code works
correctly and meets our guidelines. Our guidelines are:

You can simply run `make checkstyle`, and if you faced any formatting problem, run `make format`.

##### Run `make checkstyle` to ensure that your code is formatted correctly
- It runs `flutter analyze` to verify that there is no any warning or error.
- It runs `flutter format --set-exit-if-changed --dry-run .` to verify that code has formatted correctly.

#### Run `make format` to reformat the code
- It runs `flutter format .` to format your code.


#### Run `make runTests` to ensure that all tests are passing.
- It runs `flutter test` under the hood.

#### Run `make sure` before pushing your code.
- It runs both `make runTests` and then `make checkstyle` sequentially with a single command.

## Test coverage (unit tests)
We should write unit-test for our written code. If you are not familiar with unit-tests, please start from [here](https://docs.flutter.dev/cookbook/testing/unit/introduction).

[Mockito](https://pub.dev/packages/mockito) is the library that we use to mock our classes, please read more about it from their docs [here](https://github.com/dart-lang/mockito#lets-create-mocks).

Our code coverage is calculated by [Codecov](https://app.codecov.io/gh/imaNNeoFighT/fl_chart) (Our coverage is [![codecov](https://codecov.io/gh/imaNNeoFighT/fl_chart/branch/master/graph/badge.svg?token=XBhsIZBbZG)](https://codecov.io/gh/imaNNeoFighT/fl_chart)
 at the moment)

When you push something in your PR (after approving your PR by one of us), you see a coverage report which describes how much coverage is increased or decreased by your code (You can check the details to see which part of your code made the change). 

Please make sure that your code is **not decreasing** the coverage.

## Changelog
We have a file called [CHANGELOG.md](https://github.com/imaNNeoFighT/fl_chart/blob/master/CHANGELOG.md) which contains the history of our versions.

Please check it to understand how it works and how is the convention. Simply new versions added at the top of the CHANGELOG.md file. You can find the [first version (oldest)](https://github.com/imaNNeoFighT/fl_chart/blob/master/CHANGELOG.md#001---released-on-2019-june-4) at the bottom of the file.

When you are done in your PR, it's time to write a changelog for you changes. 

Most of the times, there will be a [newVersion](https://github.com/imaNNeoFighT/fl_chart/blob/master/CHANGELOG.md#newversion) tag at the top of the `CHANGELOG.md` file in the `master` branch. If it doesn't exist, you can write it and write your change below that.

Each change should be started with one of the following prefixes:
1. **IMPROVEMENT** (When you are improving something, for example improving performance)

2. **BREAKING** (When it breaks something, for example renaming something to something else, or removing something, ...)

3. **BUGFIX** (When you fix a bug or an issue)

4. **FEATURE** (When you are adding a feature to the library, for example allowing user to change the stroke color of something, or when you add a new concept or anything else)

In front of a prefix, you should write about your change. Don't forget to mention the related issues.

If your change has two (or more) prefixes, describe them in separate lines independently.


## Creating a Pull Request

Congratulations! Your code meets all of our guidelines :100:. Now you have to
submit a pull request (or PR for short) to us. These are the steps you should
follow when creating a PR:
 
- Make a descriptive title that summarizes what changes were in the PR.

- Mention the issues that you are fixing (if doesn't exist, try to make one and explain the issue clearly)

- Change your code according to feedback (if any).

After you follow the above steps, your PR will hopefully be merged. Thanks for
contributing!
