<!-- Copied from Matcher. -->

## Whitespace

*This is not arbitrary, it's to preserve sanity in cases like working with Git when trailing whitespace makes a big mess.*

### [EditorConfig](http://editorconfig.org/)

EditorConfig is a specification of **how editor should treat whitespace**. There are [plugins for most common editors](http://editorconfig.org/#download). Please do **get plugin for your editor** to make sure we're all on the same page!

Our `.editorconfig` is **placed in the top-level** repository. Subrepositories **might have their own** configurations, but in most of the cases there's no need for it. Our settings will:

* **Trim** trailing whitespace.
* Always **indent** by 2 spaces. No tabs.
* Make sure file ends with \n.
