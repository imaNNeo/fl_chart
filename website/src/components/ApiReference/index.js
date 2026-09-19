import React from 'react';
import clsx from 'clsx';

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
  name,
  type,
  defaultValue,
  required,
  deprecated,
  children,
}) {
  const isDeprecated = deprecated != null;
  return (
    <div
      id={id}
      className={clsx(styles.property, isDeprecated && styles.deprecated)}>
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
