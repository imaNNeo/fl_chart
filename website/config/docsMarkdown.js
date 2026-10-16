// Turns the GitHub markdown of repo_files/documentations into MDX pages,
// without copying it: it runs as Docusaurus' markdown hooks.
import fs from 'node:fs';
import path from 'node:path';

import {gitRef} from './docsVersion.js';

const githubBlobUrl = `https://github.com/imaNNeo/fl_chart/blob/${gitRef}`;

// `<!-- api:LineChartBarData -->` ... `<!-- /api -->`, see tool/api_docs.
const apiMarker = /<!-- api:(\w+)(?: \w+)? -->\n[\s\S]*?<!-- \/api -->/g;

// Tags that are kept as JSX, any other `<` is plain text (like `List<int>`).
const htmlTags =
  'a|img|br|p|div|span|details|summary|sub|sup|b|i|em|strong|video|table|thead|tbody|tr|td|th|ul|ol|li|code|pre|kbd';

/**
 * Converts a documentation file to MDX: API markers become `<ApiReference>`
 * blocks (built from api.json), and the GitHub-only markdown is made MDX-safe.
 */
export function preprocessDoc(fileContent, apiJsonPath) {
  const api = JSON.parse(fs.readFileSync(apiJsonPath, 'utf8'));
  const references = [];
  const content = fileContent.replace(apiMarker, (_, typeName) => {
    references.push(apiReferenceMdx(typeName, api));
    return `\u0000${references.length - 1}\u0000`;
  });
  return mdxSafe(content).replace(/\u0000(\d+)\u0000/g, (_, i) => references[i]);
}

function apiReferenceMdx(typeName, api) {
  const type = api[typeName];
  if (!type) {
    throw new Error(`${typeName} is missing in api.json, run \`make docs\`.`);
  }
  const js = (value) => `{${JSON.stringify(value)}}`;
  const lines = [];
  if (type.inheritsFrom) {
    const {name, link} = type.inheritsFrom;
    lines.push(mdxSafe(`Also has the properties of [\`${name}\`](${link}).`), '');
  }
  lines.push(`<ApiReference typeName=${js(typeName)} mode=${js(type.mode)}>`, '');
  for (const member of type.members) {
    const attributes = [
      `id=${js(`${typeName}-${member.name}`.toLowerCase())}`,
      `typeName=${js(typeName)}`,
      `mode=${js(type.mode)}`,
      `name=${js(member.name)}`,
      member.type && `type=${js(member.type)}`,
      member.defaultValue && `defaultValue=${js(member.defaultValue)}`,
      member.required && 'required',
      member.deprecated != null && `deprecated=${js(member.deprecated)}`,
    ].filter(Boolean);
    lines.push(
      `<ApiProperty ${attributes.join(' ')}>`,
      '',
      mdxSafe(member.description),
      '',
      '</ApiProperty>',
      '',
    );
  }
  lines.push('</ApiReference>');
  return lines.join('\n');
}

/** Makes GitHub markdown valid MDX, leaving code blocks and spans as-is. */
function mdxSafe(markdown) {
  return markdown
    .split(/(```[\s\S]*?```|`[^`\n]*`)/)
    .map((part, i) => (i % 2 === 1 ? part : mdxSafeText(part)))
    .join('');
}

function mdxSafeText(text) {
  return (
    text
      .replace(/<!--[\s\S]*?-->/g, '')
      // JSX needs `<img ... />`, `<br />` and quoted attribute values.
      .replace(/<(img|br)\b([^>]*?)\s*\/?>/gi, (_, tag, attributes) => {
        const quoted = attributes.replace(/(\s[\w-]+)=([^"'\s>]+)/g, '$1="$2"');
        return `<${tag}${quoted} />`;
      })
      .replace(/[{}]/g, (brace) => `\\${brace}`)
      .replace(new RegExp(`<(?!/?(${htmlTags})\\b)`, 'gi'), '&lt;')
      // `/example/...` points to the repository, not to the website.
      .replace(/\]\((\/[^)\s]*)\)/g, `](${githubBlobUrl}$1)`)
      // Heading ids are lowercase (GitHub doesn't mind the case, we do).
      .replace(/\]\(([^)\s]*#)([^)\s]+)\)/g, (_, target, anchor) =>
        target.startsWith('http') ? `](${target}${anchor})` : `](${target}${anchor.toLowerCase()})`,
      )
  );
}

/**
 * The class a page shows in its playground panel before a property is picked:
 * its first API block of a class (not an enum, nor a read-only class).
 */
export function playgroundType(fileContent, apiJsonPath) {
  const api = JSON.parse(fs.readFileSync(apiJsonPath, 'utf8'));
  for (const [, typeName] of fileContent.matchAll(apiMarker)) {
    if (api[typeName]?.mode === 'constructor') return typeName;
  }
  return undefined;
}

/**
 * Gives every documentation file a title and a short slug
 * (line_chart.md -> "Line Chart" at /docs/line-chart), unless it sets them.
 */
export function docFrontMatter(filePath, docsDir) {
  const relativePath = path.relative(docsDir, filePath).split(path.sep).join('/');
  const stem = path.basename(relativePath, '.md');
  const migration = relativePath.match(/^migration_guides\/([^/]+)\/[^/]+\.md$/);
  if (migration) {
    return {title: `Migrate to ${migration[1]}`, slug: `/migration-guides/${migration[1]}`};
  }
  if (relativePath === 'migration_guides/INDEX.md') {
    return {title: 'Migration Guides', slug: '/migration-guides'};
  }
  if (relativePath === 'index.md') {
    return {title: 'Introduction', slug: '/'};
  }
  return {
    title: stem
      .split('_')
      .map((word) => word[0].toUpperCase() + word.slice(1))
      .join(' '),
    slug: `/${stem.replaceAll('_', '-')}`,
  };
}
