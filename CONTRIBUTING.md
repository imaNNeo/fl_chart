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

- Make sure the code passes the tests. To run tests, run `flutter test`.

- Make sure to run `flutter analyze` and resolve any warnings or errors.

- The code should be formatted correctly. For Visual Studio Code users, this is
  automatically enforced. Otherwise, you can run this command inside the
  project from the command line: `flutter format --line-length 100 .`.
  We use `flutter format --set-exit-if-changed --dry-run --line-length 100 .` command in CI.

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
