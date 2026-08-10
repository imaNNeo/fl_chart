# Contributing
Hello, we are glad to have a contributor like you here.  

Don't forget that `open-source` makes no sense without contributors. No matter how big your changes are, it helps us a lot, even if it is just a line of change.

This file is intended to be a guide for those who are interested in contributing to the FL Chart.

#### Below are the people who have contributed to FL Chart. We hope to have your picture here soon.
[![](https://opencollective.com/fl_chart/contributors.svg?width=890&button=false)](https://github.com/imaNNeo/fl_chart/graphs/contributors)

## Let's get Started

Make sure you have Flutter installed and on your path (follow the [installation guide](https://docs.flutter.dev/get-started/install)).

Follow these steps to clone FL Chart and set up the development environment:

1. Fork the repository

2. Clone the project, you can find it in your repositories: `git clone https://github.com/your-username/fl_chart.git`

3. Go into the cloned directory: `cd fl_chart`

4. Install all packages: `flutter packages get`

5. Try to run the sample app. It should work on all platforms (Android, iOS, Web, Linux, MacOS, Windows)

6. Create a new branch for your changes: `git checkout -b your-branch-name`.
   The branch name doesn't matter for our project history (as we use **Squash and Merge**), but it's good practice to use descriptive names. You can [read more about naming conventions here](https://www.geeksforgeeks.org/git/how-to-naming-conventions-for-git-branches/).

## Before Modifying the Code

If the work you intend to do is non-trivial, it is necessary to open
an issue before starting to write your code. This helps us and the
community to discuss the issue and choose what is deemed to be the
best solution.

### Mention the related issues:
If you are going to fix or improve something, please find and mention the related issues in commit message and Pull Request description.
In case you couldn't find any issue, it's better to create an issue to explain what's the issue that you are going to fix.

## Let's start by our drawing architecture
We have a *_chart_painter.dart class per each chart type. It draws elements into the Canvas.
We made the CanvasWrapper class, because we wanted to test draw functions.
CanvasWrapper class holds a canvas and all draw functions proxies through it.
You should use it for drawing on the canvas, Instead of directly accessing the canvas.
It makes draw functions testable.

<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/architecture/fl_chart_architecture.jpg" />

(made with [draw.io](https://drive.google.com/file/d/1bj-2TqTRUh80dRKJk10drPNeA3fp3EA8/view))

## Keep your branch updated
If your branch falls behind the `main` branch, you can update it using the "Update branch" button on GitHub or by merging `main` into your branch.

We use **Squash and Merge**, which combines all your PR commits into a single, clean commit in the `main` branch.

## Checking Your Code's Quality

After you have made your changes, you have to make sure your code works
correctly and meets our guidelines. Our guidelines are:

You can simply run `make checkstyle`, and if you faced any formatting problem, run `make format`.

##### Run `make checkstyle` to ensure that your code is formatted correctly
- It runs `flutter analyze` to verify that there are no warnings or errors.
- It runs `dart format --set-exit-if-changed --dry-run .` to verify that code has formatted correctly.

#### Run `make format` to reformat the code
- It runs `dart format .` to format your code.


#### Run `make runTests` to ensure that all tests are passing.
- It runs `flutter test` under the hood.

#### Run `make sure` before pushing your code.
- It runs both `make runTests` and then `make checkstyle` sequentially with a single command.

## Test coverage (unit tests)
We should write unit tests for our written code. If you are not familiar with unit-tests, please start from [here](https://docs.flutter.dev/cookbook/testing/unit/introduction).

[Mockito](https://pub.dev/packages/mockito) is the library that we use to mock our classes. Please read more about it in their docs [here](https://github.com/dart-lang/mockito#lets-create-mocks).

Our code coverage is calculated by [Codecov](https://app.codecov.io/gh/imaNNeo/fl_chart) (Our coverage is [![codecov](https://codecov.io/gh/imaNNeo/fl_chart/branch/main/graph/badge.svg?token=XBhsIZBbZG)](https://codecov.io/gh/imaNNeo/fl_chart)
 at the moment)

When you push something in your PR (after your PR is approved by one of us), you will see a coverage report that describes how much coverage is increased or decreased by your code (You can check the details to see which part of your code made the change). 

Please make sure that your code is **not decreasing** the coverage.

## Creating a Pull Request

Congratulations! Your code meets all of our guidelines :100:. Now you have to
submit a pull request (PR for short) to us. These are the steps you should
follow when creating a PR:

### PR Title Convention
We use [Conventional Commits](https://www.conventionalcommits.org/) for our PR titles. This title will be used to automatically generate the **CHANGELOG**.

The title must follow this format:
`<type>: <Subject>`

- **Type**: Must be one of `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- **Subject**: Must start with a **Capital Letter** and adequately summarize the changes.
- **Breaking Changes**: If your PR contains a breaking change, add a `!` after the type (e.g., `feat!: Change PieChart API`).

**Examples:**
- `feat: Add rounded corners to PieChart`
- `fix: Resolve memory leak in BarChart`
- `docs: Update BarChart documentation`

A GitHub Action will validate your PR title and will fail if it doesn't follow this convention.

### PR Description
- Use the provided PR template.
- Provide a concise description of the changes. This text will become the permanent commit body in our Git history, so please keep it clear and brief. (Tip: Feel free to use AI assistants to help you draft this!)
- Mention the issues that you are fixing (e.g., `Closes #1234`).
- If it's a breaking change, provide migration instructions in the "Migration instructions" section of the template.

After you follow the above steps, your PR will hopefully be merged. Thanks for contributing!
