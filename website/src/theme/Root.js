// Wraps every page, to show the old-version banner above the navbar.
import React from 'react';

import {VersionBanner} from '@site/src/components/DocsVersions';

export default function Root({children}) {
  return (
    <>
      <VersionBanner />
      {children}
    </>
  );
}
