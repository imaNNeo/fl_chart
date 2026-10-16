// Puts the new builds of the website into the current flchart.dev site (the
// gh-pages branch of imaNNeo/fl_chart_landing), and updates its versions.json.
//
//   node assemble-pages.mjs --site <gh-pages checkout> --builds <dir>
//       --version <main|1.3.x> [--stable]
//
// Each folder of <dir> is a build: `main` and `1.3.x` replace the folder of the
// same name, `root` replaces the root of the site (everything but the version
// folders), only with --stable and if it's not older than the current stable.
import fs from 'node:fs';
import path from 'node:path';
import {parseArgs} from 'node:util';

const {values: args} = parseArgs({
  options: {
    site: {type: 'string'},
    builds: {type: 'string'},
    version: {type: 'string'},
    stable: {type: 'boolean', default: false},
  },
});
if (!args.site || !args.builds || !args.version) {
  throw new Error('--site, --builds and --version are required');
}

const versionName = /^(main|\d+\.\d+\.(\d+|x))$/;
const versionsFile = path.join(args.site, 'versions.json');

/** {"stable": "1.3.x", "versions": [{"name": "main", "path": "/main/"}, ...]} */
const versions = fs.existsSync(versionsFile)
  ? JSON.parse(fs.readFileSync(versionsFile, 'utf8'))
  : {stable: null, versions: []};

function replaceWith(source, target) {
  fs.rmSync(target, {recursive: true, force: true});
  fs.cpSync(source, target, {recursive: true});
}

/** Negative if a is older than b. main is newer than any release. */
function compareVersions(a, b) {
  const parts = (name) =>
    name === 'main'
      ? [Infinity]
      : name.split('.').map((part) => (part === 'x' ? Infinity : Number(part)));
  const [pa, pb] = [parts(a), parts(b)];
  for (let i = 0; i < Math.max(pa.length, pb.length); i++) {
    const diff = (pa[i] ?? 0) - (pb[i] ?? 0);
    if (diff !== 0 && !Number.isNaN(diff)) return diff;
  }
  return 0;
}

const builds = fs.readdirSync(args.builds);

for (const folder of builds.filter((build) => build !== 'root')) {
  if (!versionName.test(folder)) {
    throw new Error(`Not a version folder: ${folder}`);
  }
  replaceWith(path.join(args.builds, folder), path.join(args.site, folder));
  if (!versions.versions.some((version) => version.name === folder)) {
    versions.versions.push({name: folder, path: `/${folder}/`});
  }
  console.log(`Deployed ${folder} to /${folder}/`);
}

if (builds.includes('root')) {
  const isNewest =
    !versions.stable || compareVersions(args.version, versions.stable) >= 0;
  if (args.stable && isNewest) {
    const kept = new Set([
      'versions.json',
      ...versions.versions.map((version) => version.name),
    ]);
    for (const entry of fs.readdirSync(args.site)) {
      if (!kept.has(entry)) {
        fs.rmSync(path.join(args.site, entry), {recursive: true, force: true});
      }
    }
    for (const entry of fs.readdirSync(path.join(args.builds, 'root'))) {
      if (kept.has(entry)) {
        throw new Error(`The root build has a version folder: ${entry}`);
      }
      fs.cpSync(
        path.join(args.builds, 'root', entry),
        path.join(args.site, entry),
        {recursive: true},
      );
    }
    versions.stable = args.version;
    console.log(`Deployed ${args.version} to / as the stable version`);
  } else {
    console.log(
      `Kept the root at ${versions.stable}: ${args.version} is not the newest stable version`,
    );
  }
}

versions.versions.sort((a, b) => compareVersions(b.name, a.name));
fs.writeFileSync(versionsFile, `${JSON.stringify(versions, null, 2)}\n`);
console.log(JSON.stringify(versions));
