// Which version of the docs this build is, set by the Website workflow.
//
// flchart.dev has one build per version: the latest stable release at the root,
// `main` in /main/ and each release line in its own folder (like /1.3.x/). The
// version switcher and the old-version banner read /versions.json, which the
// deploy keeps up to date (see scripts/assemble-pages.mjs).

/** Where this build is served: `/`, `/main/` or `/1.3.x/`. */
export const baseUrl = process.env.DOCS_BASE_URL || '/';

/** The version these docs are for: `main` or a release line like `1.3.x`. */
export const docsVersion = process.env.DOCS_VERSION || 'main';

/** The git ref the docs link to for the source code of the samples. */
export const gitRef = process.env.DOCS_GIT_REF || 'main';
