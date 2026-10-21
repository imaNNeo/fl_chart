// Adds the version switcher as a navbar item type (`custom-versionSwitcher`).
import ComponentTypes from '@theme-original/NavbarItem/ComponentTypes';

import {VersionSwitcher} from '@site/src/components/DocsVersions';

export default {
  ...ComponentTypes,
  'custom-versionSwitcher': VersionSwitcher,
};
