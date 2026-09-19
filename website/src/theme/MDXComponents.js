import MDXComponents from '@theme-original/MDXComponents';
import ApiReference, {ApiProperty} from '@site/src/components/ApiReference';

// Available in every doc page without an import, the API blocks of the docs
// are turned into these components (see config/docsMarkdown.js).
export default {
  ...MDXComponents,
  ApiReference,
  ApiProperty,
};
