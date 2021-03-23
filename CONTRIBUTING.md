# Contributing

This file is intended to be a guide for those interested in contributing to FL Chart.

## Getting Started

Make sure you have Flutter installed and on your path.

Follow these steps to clone FL Chart and set up the development environment:

1. Clone the project: `git clone https://github.com/imaNNeoFighT/fl_chart.git`

2. Go into the cloned directory: `cd fl_chart`

3. Install all packages: `flutter packages get`

## Before Modifying the Code

If the work you intend to do is non-trivial, it is necessary to open
an issue before starting writing your code. This helps us and the
community to discuss the issue and choose what is deemed to be the
best solution.

## Switch to `dev` branch

You should make your changes upon the `dev` branch (All development changes happen in the `dev` branch, then I publish a new version and merge them into the `master`)


## Drawing architecture
We have a *_chart_painter.dart class per each chart type. It draws elements into the Canvas.
We made the CanvasWrapper class, because we wanted to test draw functions.
CanvasWrapper class holds a canvas and all draw functions proxies through it.
You should use it for drawing on the canvas, Instead of direct accessing to canvas.
It makes draw functions testable.


## Checking Your Code's Quality

After you have made your changes, you have to make sure your code works
correctly and meets our guidelines. Our guidelines are:

You can simply run `make checkstyle`, and if you faced any formatting problem, run `make format`.

##### Run `make checkstyle` to ensure that your code is formatted correctly
- It runs `flutter analyze` to verify that there is no any warning or error.
- It runs `flutter format --set-exit-if-changed --dry-run --line-length 100 .` to verify that code has formatted correctly.

#### Run `make format` to reformat the code
- It runs `flutter format --line-length 100 .` to format your code with 100 characters limit.


#### Run `make runTests` to ensure that all tests are passing.
- It runs `flutter test` under the hood.

## Creating a Pull Request

Congratulations! Your code meets all of our guidelines :100:. Now you have to
submit a pull request (or PR for short) to us. These are the steps you should
follow when creating a PR:

- Make sure you select `dev` branch as your target branch.
  
- Make a descriptive title that summarizes what changes were in the PR.

- Link to issues that this PR will fix (if any).

- If your PR adds a feature or fixes a bug, it must add one or more tests.

- Change your code according to feedback (if any).

After you follow the above steps, your PR will hopefully be merged. Thanks for
contributing!
