// Ejected from @docusaurus/theme-classic (DocItem/Layout) to show the
// playground panel on the pages that have API blocks: in the right column
// instead of the table of contents, which moves to the top of the page.
import React from 'react';
import clsx from 'clsx';
import {ThemeClassNames, useWindowSize} from '@docusaurus/theme-common';
import {useDoc} from '@docusaurus/plugin-content-docs/client';
import DocItemPaginator from '@theme/DocItem/Paginator';
import DocVersionBanner from '@theme/DocVersionBanner';
import DocVersionBadge from '@theme/DocVersionBadge';
import DocItemFooter from '@theme/DocItem/Footer';
import DocItemTOCMobile from '@theme/DocItem/TOC/Mobile';
import DocItemTOCDesktop from '@theme/DocItem/TOC/Desktop';
import DocItemContent from '@theme/DocItem/Content';
import DocBreadcrumbs from '@theme/DocBreadcrumbs';
import ContentVisibility from '@theme/ContentVisibility';
import TOCCollapsible from '@theme/TOCCollapsible';

import {PlaygroundPanel, PlaygroundProvider} from '@site/src/components/Playground';

import styles from './styles.module.css';

/**
 * Decide if the toc should be rendered, on mobile or desktop viewports
 */
function useDocTOC() {
  const {frontMatter, toc} = useDoc();
  const windowSize = useWindowSize();

  const hidden = frontMatter.hide_table_of_contents;
  const canRender = !hidden && toc.length > 0;

  const mobile = canRender ? <DocItemTOCMobile /> : undefined;

  const desktop =
    canRender && (windowSize === 'desktop' || windowSize === 'ssr') ? (
      <DocItemTOCDesktop />
    ) : undefined;

  return {
    hidden,
    mobile,
    desktop,
  };
}

export default function DocItemLayout({children}) {
  const {frontMatter} = useDoc();
  return frontMatter.playground ? (
    <PlaygroundLayout typeName={frontMatter.playground}>
      {children}
    </PlaygroundLayout>
  ) : (
    <DefaultLayout>{children}</DefaultLayout>
  );
}

function DefaultLayout({children}) {
  const docTOC = useDocTOC();
  const {metadata} = useDoc();
  return (
    <div className="row">
      <div className={clsx('col', !docTOC.hidden && styles.docItemCol)}>
        <ContentVisibility metadata={metadata} />
        <DocVersionBanner />
        <div className={styles.docItemContainer}>
          <article>
            <DocBreadcrumbs />
            <DocVersionBadge />
            {docTOC.mobile}
            <DocItemContent>{children}</DocItemContent>
            <DocItemFooter />
          </article>
          <DocItemPaginator />
        </div>
      </div>
      {docTOC.desktop && <div className="col col--3">{docTOC.desktop}</div>}
    </div>
  );
}

function PlaygroundLayout({typeName, children}) {
  const {metadata, frontMatter, toc} = useDoc();
  return (
    <PlaygroundProvider typeName={typeName}>
      <div className="row">
        <div className="col">
          <ContentVisibility metadata={metadata} />
          <DocVersionBanner />
          <div
            className={clsx(styles.docItemContainer, styles.playgroundContent)}>
            <article>
              <DocBreadcrumbs />
              <DocVersionBadge />
              {toc.length > 0 && (
                <TOCCollapsible
                  toc={toc}
                  minHeadingLevel={frontMatter.toc_min_heading_level}
                  maxHeadingLevel={frontMatter.toc_max_heading_level}
                  className={clsx(
                    ThemeClassNames.docs.docTocMobile,
                    styles.toc,
                  )}
                />
              )}
              <DocItemContent>{children}</DocItemContent>
              <DocItemFooter />
            </article>
            <DocItemPaginator />
          </div>
        </div>
        <div className={clsx('col', styles.playgroundCol)}>
          <PlaygroundPanel />
        </div>
      </div>
    </PlaygroundProvider>
  );
}
