# flchart.dev

The FL Chart website, built with [Docusaurus](https://docusaurus.io/). It needs Node 20 or newer
(with [nvm](https://github.com/nvm-sh/nvm), run `nvm use` in this folder), and Flutter for the
live previews.

```bash
cd website
npm install               # once
npm run build:playground  # once, and after changing ../playground (for the live previews)
npm start                 # dev server on http://localhost:3000, with live reload
npm run build             # production build (fails on broken links), then `npm run serve` to check it
```

## Docs

The docs pages are not stored here: they are the markdown files of
[`repo_files/documentations`](../repo_files/documentations), which Docusaurus reads in place
(see `docusaurus.config.js`). So edit the docs there, they also render on GitHub, and
`npm start` reloads the page when you save them.

The API blocks of the docs (`<!-- api:LineChartBarData -->` ... `<!-- /api -->`) are generated
from the dartdoc of the library by `make docs` (from the repository root), which also writes
`src/data/api.json`. On the website, these blocks are rendered by the `ApiReference` component
from that file (see `config/docsMarkdown.js`). So after changing a `///` comment in `lib/`, run
`make docs` to see it on the website.

## Live previews

The pages with API blocks have a live preview panel: clicking a property shows it in a real chart,
with a control to change it. The panel is the Flutter app of [`../playground`](../playground),
built into `static/playground` by `npm run build:playground` (see `src/components/Playground` and
`src/theme/DocItem/Layout`).

## Versions

flchart.dev has one build of this website per version, deployed by the `Website` workflow
(`.github/workflows/website.yml`) to the `gh-pages` branch of
[imaNNeo/fl_chart_landing](https://github.com/imaNNeo/fl_chart_landing):

- `/` is the latest stable release, the default version. Only this one is indexed by search engines.
- `/main/` is the `main` branch, deployed on each push to `main`.
- `/1.3.x/` (and so on) is a release line, deployed when one of its releases is published (1.3.2
  replaces 1.3.1 there). A release of the newest line also replaces the root.

Each build is made from its own git ref, so it has that version's docs, API tables and playground.
The build gets its version from the `DOCS_BASE_URL`, `DOCS_VERSION` and `DOCS_GIT_REF` environment
variables (see `config/docsVersion.js`); without them it's `main` at the root, like `npm start`.

The deploy adds each version to `/versions.json` at the root of the site (see
`scripts/assemble-pages.mjs`). The version switcher of the navbar and the banner of the old versions
read it at runtime (see `src/components/DocsVersions`), so an old build still lists the versions
released after it.
