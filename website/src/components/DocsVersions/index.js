import React, {useEffect, useState} from 'react';
import clsx from 'clsx';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import {useLocation} from '@docusaurus/router';

import styles from './styles.module.css';

// Written by the deploy at the root of flchart.dev (see
// scripts/assemble-pages.mjs), so every build, even an old one, sees the
// versions released after it:
// {"stable": "1.3.x", "versions": [{"name": "main", "path": "/main/"}, ...]}
const versionsUrl = '/versions.json';

let versionsPromise;
function fetchVersions() {
  versionsPromise ??= fetch(versionsUrl)
    .then((response) => (response.ok ? response.json() : null))
    .catch(() => null);
  return versionsPromise;
}

/** Null until /versions.json is loaded, and when there is none (`npm start`). */
function useVersions() {
  const [versions, setVersions] = useState(null);
  useEffect(() => {
    fetchVersions().then(setVersions);
  }, []);
  return versions;
}

/** The version of this build, its base url, and the page path below it. */
function useCurrent() {
  const {siteConfig} = useDocusaurusContext();
  const {pathname} = useLocation();
  const {baseUrl} = siteConfig;
  return {
    name: siteConfig.customFields.docsVersion,
    isRoot: baseUrl === '/',
    pagePath: pathname.startsWith(baseUrl)
      ? pathname.slice(baseUrl.length)
      : pathname.replace(/^\//, ''),
  };
}

/** Where a version is served: the stable one at the root. */
function versionPath(versions, version) {
  return version.name === versions.stable ? '/' : version.path;
}

function versionLabel(versions, version) {
  return version.name === versions.stable
    ? `${version.name} (stable)`
    : version.name;
}

/**
 * The navbar dropdown to see the docs of another version, on the same page
 * (`type: 'custom-versionSwitcher'` in docusaurus.config.js).
 */
export function VersionSwitcher({mobile}) {
  const versions = useVersions();
  const current = useCurrent();
  const currentLabel =
    versions && current.name === versions.stable
      ? `${current.name} (stable)`
      : current.name;

  // Each version is a separate build: a full page load, not a client route.
  const items = (versions?.versions ?? []).map((version) => (
    <a
      key={version.name}
      href={`${versionPath(versions, version)}${current.pagePath}`}
      target="_self"
      className={clsx(
        mobile ? 'menu__link' : 'dropdown__link',
        version.name === current.name &&
          (mobile ? 'menu__link--active' : 'dropdown__link--active'),
      )}>
      {versionLabel(versions, version)}
    </a>
  ));

  if (mobile) {
    return (
      <li className="menu__list-item">
        <span className={clsx('menu__link', styles.mobileTitle)}>
          Version: {currentLabel}
        </span>
        {items.length > 0 && (
          <ul className="menu__list">
            {items.map((item) => (
              <li key={item.key} className="menu__list-item">
                {item}
              </li>
            ))}
          </ul>
        )}
      </li>
    );
  }

  return (
    <div className="navbar__item dropdown dropdown--hoverable">
      <span
        className={clsx('navbar__link', styles.toggle)}
        aria-haspopup="true"
        role="button"
        tabIndex={0}>
        {currentLabel}
      </span>
      {items.length > 0 && (
        <ul className="dropdown__menu">
          {items.map((item) => (
            <li key={item.key}>{item}</li>
          ))}
        </ul>
      )}
    </div>
  );
}

/**
 * Above the pages of main and of the old releases: a link to the same page
 * in the latest stable release.
 */
export function VersionBanner() {
  const versions = useVersions();
  const current = useCurrent();
  if (current.isRoot) {
    return null;
  }
  const stable = versions?.stable;
  if (versions && current.name === stable) {
    return null;
  }
  const isMain = current.name === 'main';
  // Without versions.json, main still knows it's unreleased.
  if (!isMain && !stable) {
    return null;
  }
  return (
    <div className={styles.banner} role="status">
      {isMain ? (
        <>
          You're viewing the docs of the unreleased <code>main</code> branch.
        </>
      ) : (
        <>
          You're viewing the docs of fl_chart <strong>{current.name}</strong>.
        </>
      )}{' '}
      {/* Another build: a full page load, without this build's base url. */}
      <a href={`/${current.pagePath}`} target="_self">
        See the latest stable version{stable ? ` (${stable})` : ''}
      </a>
      .
    </div>
  );
}
