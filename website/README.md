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
