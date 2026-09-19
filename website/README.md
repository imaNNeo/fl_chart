# flchart.dev

The FL Chart website, built with [Docusaurus](https://docusaurus.io/). It needs Node 20 or newer.

```bash
npm install
npm start       # local dev server with live reload
npm run build   # production build, fails on broken links
```

## Docs

The docs pages are not stored here: they are the markdown files of
[`repo_files/documentations`](../repo_files/documentations), which Docusaurus reads in place
(see `docusaurus.config.js`). So edit the docs there, they also render on GitHub.

The API blocks of the docs (`<!-- api:LineChartBarData -->` ... `<!-- /api -->`) are generated
from the dartdoc of the library by `make docs`, which also writes `src/data/api.json`. On the
website, these blocks are rendered by the `ApiReference` component from that file
(see `config/docsMarkdown.js`).
