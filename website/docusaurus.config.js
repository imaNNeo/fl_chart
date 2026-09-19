// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import path from 'node:path';

import {docFrontMatter, preprocessDoc} from './config/docsMarkdown.js';

// The docs live in the fl_chart repository, next to the code they document.
const docsDir = path.resolve(__dirname, '../repo_files/documentations');
// Generated from the dartdoc by `make docs` (tool/api_docs).
const apiJsonPath = path.resolve(__dirname, 'src/data/api.json');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'FL Chart',
  tagline: 'Highly customizable flutter chart library',
  favicon: 'img/favicon.ico',

  url: 'https://flchart.dev',
  baseUrl: '/',
  organizationName: 'imaNNeo',
  projectName: 'fl_chart',
  deploymentBranch: 'gh-pages',
  trailingSlash: false,

  onBrokenLinks: 'throw',
  onBrokenAnchors: 'throw',

  markdown: {
    hooks: {
      onBrokenMarkdownLinks: 'throw',
    },
    preprocessor: ({filePath, fileContent}) =>
      filePath.startsWith(docsDir)
        ? preprocessDoc(fileContent, apiJsonPath)
        : fileContent,
    parseFrontMatter: async (params) => {
      const result = await params.defaultParseFrontMatter(params);
      if (params.filePath.startsWith(docsDir)) {
        result.frontMatter = {
          ...docFrontMatter(params.filePath, docsDir),
          ...result.frontMatter,
        };
      }
      return result;
    },
  },

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          path: docsDir,
          sidebarPath: './sidebars.js',
          // Keeps folders like `0.50.0` as they are (not as sort prefixes).
          numberPrefixParser: false,
          editUrl: ({docPath}) =>
            `https://github.com/imaNNeo/fl_chart/edit/main/repo_files/documentations/${docPath}`,
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      },
    ],
  ],

  themeConfig: {
    image: 'img/social_preview.jpg',
    colorMode: {
      defaultMode: 'dark',
      disableSwitch: true,
      respectPrefersColorScheme: false,
    },
    navbar: {
      logo: {
        alt: 'FL Chart Logo',
        src: 'img/logo_with_text.svg',
      },
      items: [
        {
          to: '/docs',
          label: 'Docs',
          position: 'right',
        },
        {
          href: 'https://app.flchart.dev/',
          label: 'Examples App',
          position: 'right',
        },
        {
          href: 'https://github.com/imaNNeo/fl_chart',
          label: 'GitHub',
          position: 'right',
        },
        {
          href: 'https://www.youtube.com/playlist?list=PL1-_rCwRcnbNpvodmbt43O81wMUdBv8-a',
          label: 'Tutorials',
          position: 'right',
        },
        {
          href: '/download',
          label: 'Download',
          position: 'right',
        },
        {
          href: '/about',
          label: 'About',
          position: 'right',
        },
      ],
    },
    footer: {
      links: [
        {
          to: '/about',
          label: 'About',
        },
        {
          to: '/docs',
          label: 'Docs',
        },
        {
          to: 'https://www.youtube.com/playlist?list=PL1-_rCwRcnbNpvodmbt43O81wMUdBv8-a',
          label: 'Tutorials',
        },
        {
          to: 'https://github.com/imaNNeo/fl_chart',
          label: 'Source code',
        },
        {
          href: '/about#-speed-up-fl-chart-with-your-support',
          label: 'Support FL Chart',
          position: 'right',
        },
        {
          to: 'https://github.com/imaNNeo/fl_chart/tree/main/website',
          label: 'Website source code',
        },
        {
          to: 'https://flutter4fun.com/ui-challenge-7/',
          label: 'Flutter 4 Fun',
        },
        {
          to: 'https://github.com/imaNNeo/fl_chart/issues/new/choose',
          label: 'Report and issue',
        },
        {
          to: 'https://github.com/imaNNeo/fl_chart/blob/master/CONTRIBUTING.md',
          label: 'Contribute',
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} FL Chart. Built with Docusaurus.`,
    },
    prism: {
      additionalLanguages: ['dart'],
    },
  },
};

export default config;
