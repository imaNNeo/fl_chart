import React, {createContext, useContext, useEffect, useRef, useState} from 'react';
import clsx from 'clsx';
import useBaseUrl from '@docusaurus/useBaseUrl';

import styles from './styles.module.css';

const PlaygroundContext = createContext(null);

/**
 * The property shown in the playground panel of a doc page, picked by
 * clicking the properties of its API blocks.
 */
export function PlaygroundProvider({typeName, children}) {
  const [target, setTarget] = useState({typeName, property: null});
  const [expanded, setExpanded] = useState(false);
  const select = (typeName, property) => {
    setTarget({typeName, property});
    setExpanded(true);
  };
  return (
    <PlaygroundContext.Provider
      value={{target, select, expanded, setExpanded}}>
      {children}
    </PlaygroundContext.Provider>
  );
}

/** Null on the pages without a playground. */
export function usePlayground() {
  return useContext(PlaygroundContext);
}

/**
 * A live preview of the picked property (the Flutter app of /playground):
 * a sticky column on wide screens, a bottom sheet on the others.
 */
export function PlaygroundPanel() {
  const {target, expanded, setExpanded} = usePlayground();
  const iframeRef = useRef(null);
  const path = `#/${target.typeName}${target.property ? `/${target.property}` : ''}`;
  const src = `${useBaseUrl('/playground/')}${path}`;
  // The iframe loads once it's visible (not in a closed bottom sheet), then
  // only its route changes: no reload, and no entry in the browser history.
  const [frameSrc, setFrameSrc] = useState(null);
  const shownSrc = useRef(null);
  useEffect(() => {
    if (frameSrc === null) {
      if (expanded || window.matchMedia(wideScreen).matches) {
        setFrameSrc(src);
        shownSrc.current = src;
      }
    } else if (shownSrc.current !== src) {
      shownSrc.current = src;
      iframeRef.current?.contentWindow?.location.replace(
        new URL(src, window.location.href).href,
      );
    }
  }, [src, expanded, frameSrc]);

  return (
    <aside className={clsx(styles.panel, expanded && styles.expanded)}>
      <div className={styles.header}>
        <button
          type="button"
          className={styles.toggle}
          aria-expanded={expanded}
          onClick={() => setExpanded(!expanded)}>
          <span className={styles.title}>Live preview</span>
          <code className={styles.target}>
            {target.typeName}
            {target.property && `.${target.property}`}
          </code>
        </button>
        <a
          className={styles.open}
          href={src}
          target="_blank"
          rel="noopener"
          title="Open in a new tab">
          ↗
        </a>
      </div>
      {frameSrc && (
        <iframe
          ref={iframeRef}
          className={styles.frame}
          src={frameSrc}
          title="FL Chart playground"
          allow="clipboard-write"
        />
      )}
    </aside>
  );
}

// Keep in sync with the media queries of styles.module.css.
const wideScreen = '(min-width: 1280px)';
