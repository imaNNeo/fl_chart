// @ts-check

// The docs are the markdown files of repo_files/documentations (see
// docusaurus.config.js), a doc id is its path there without `.md`.

/** @type {import('@docusaurus/plugin-content-docs').SidebarsConfig} */
const sidebars = {
  docs: [
    'index',
    {
      type: 'category',
      label: 'Charts',
      collapsed: false,
      items: [
        'line_chart',
        'bar_chart',
        'pie_chart',
        'scatter_chart',
        'radar_chart',
        'candlestick_chart',
        'gauge_chart',
        'base_chart',
      ],
    },
    {
      type: 'category',
      label: 'Guides',
      collapsed: false,
      items: ['handle_touches', 'handle_animations', 'handle_transformations'],
    },
    {
      type: 'category',
      label: 'Migration Guides',
      link: {type: 'doc', id: 'migration_guides/INDEX'},
      items: [
        'migration_guides/0.70.0/MIGRATION_00_70_00',
        'migration_guides/0.67.0/MIGRATION_00_67_00',
        'migration_guides/0.55.0/MIGRATION_00_55_00',
        'migration_guides/0.50.0/MIGRATION_00_50_00',
      ],
    },
  ],
};

export default sidebars;
