import React from 'react';
import clsx from 'clsx';

import {usePlayground} from '@site/src/components/Playground';

import styles from './styles.module.css';

/**
 * The properties of a documented type, generated from its dartdoc
 * (see tool/api_docs and config/docsMarkdown.js).
 */
export default function ApiReference({children}) {
  return <div className={styles.reference}>{children}</div>;
}

export function ApiProperty({
  id,
  typeName,
  mode,
  name,
  type,
  defaultValue,
  required,
  deprecated,
  children,
}) {
  const isDeprecated = deprecated != null;
  const playground = usePlayground();
  // The properties of classes (not enums or read-only classes) can be tried
  // in the playground panel of the page.
  const canTry = playground != null && mode === 'constructor';
  const isSelected =
    canTry &&
    playground.target.typeName === typeName &&
    playground.target.property === name;
  const tryIt = (event) => {
    if (event.target.closest('a')) return;
    if (event.type === 'keydown') {
      if (event.key !== 'Enter' && event.key !== ' ') return;
      event.preventDefault();
    }
    playground.select(typeName, name);
  };
  return (
    <div
      id={id}
      className={clsx(
        styles.property,
        isDeprecated && styles.deprecated,
        canTry && styles.tryable,
        isSelected && styles.selected,
      )}
      {...(canTry && {
        role: 'button',
        tabIndex: 0,
        'aria-pressed': isSelected,
        title: `Try ${name} in the live preview`,
        onClick: tryIt,
        onKeyDown: tryIt,
      })}>
      <div className={styles.signature}>
        <code className={styles.name}>{name}</code>
        {type && <code className={styles.type}>{type}</code>}
        <a className={styles.hashLink} href={`#${id}`} aria-label={`Link to ${name}`}>
          #
        </a>
        <span className={styles.badges}>
          {isDeprecated && (
            <span className={clsx(styles.badge, styles.deprecatedBadge)}>
              deprecated
            </span>
          )}
          {required && (
            <span className={clsx(styles.badge, styles.requiredBadge)}>
              required
            </span>
          )}
          {defaultValue != null && (
            <span className={styles.default}>
              <span className={styles.defaultLabel}>default</span>
              <code className={styles.defaultValue}>{defaultValue}</code>
            </span>
          )}
        </span>
      </div>
      <div className={styles.description}>
        {isDeprecated && deprecated && (
          <p className={styles.deprecationMessage}>{deprecated}</p>
        )}
        {children}
      </div>
    </div>
  );
}
