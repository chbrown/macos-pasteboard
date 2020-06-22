# macos-pasteboard

Like macOS’s built-in `pbpaste` but more flexible and raw.


## Install

```sh
git clone https://github.com/chbrown/macos-pasteboard
cd macos-pasteboard
make install
```


## Example

In a web browser, highlight and copy the “macos-pasteboard” heading at the top of this README.

`pbv --help` lists the types supported by the current contents of the clipboard. The available types depend not only on the type of object you copied, but also on which program you copied it within.

```sh
pbv --help
```

```
Usage: pbv [dataType] [-h|--help]

Available types for the 'Apple CFPasteboard general' pasteboard:
  dyn.ah62d4rv4gu8y63n2nuuhg5pbsm4ca6dbsr4gnkduqf31k3pcr7u1e3basv61a3k
  NeXT smart paste pasteboard type
  com.apple.webarchive
  Apple Web Archive pasteboard type
  public.rtf
  NeXT Rich Text Format v1.0 pasteboard type
  public.html
  Apple HTML pasteboard type
  public.utf8-plain-text
  NSStringPboardType
  com.apple.WebKit.custom-pasteboard-data
  public.utf16-external-plain-text
  CorePasteboardFlavorType 0x75743136
  dyn.ah62d4rv4gk81n65yru
  CorePasteboardFlavorType 0x7573746C
  com.apple.traditional-mac-plain-text
  CorePasteboardFlavorType 0x54455854
  dyn.ah62d4rv4gk81g7d3ru
  CorePasteboardFlavorType 0x7374796C
```

If you don’t pass a data type, `pbv` will default to outputting the plain text version (the `public.utf8-plain-text` type):

```sh
pbv
```

> `macos-pasteboard`

But in this example we want the HTML version of what we copied:

```sh
pbv public.html
```

> `<h1 style="box-sizing: border-box; font-size: 2em; margin-top: 0px !important; margin-right: 0px; margin-bottom: 16px; margin-left: 0px; font-weight: 600; line-height: 1.25; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: rgb(234, 236, 239); padding-bottom: 0.3em; caret-color: rgb(36, 41, 46); color: rgb(36, 41, 46); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Helvetica, Arial, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, &quot;Segoe UI Symbol&quot;; font-style: normal; font-variant-caps: normal; letter-spacing: normal; orphans: auto; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; text-decoration: none;">macos-pasteboard</h1>`

Using [tidy](http://www.html-tidy.org/),
[xmlstarlet](http://xmlstar.sourceforge.net/), and
[kramdown](https://kramdown.gettalong.org/),
we can convert this to Markdown without too much pain:

```sh
pbv public.html \
| tidy -quiet --show-warnings no -asxml -i -w 0 --quote-nbsp no \
| xmlstarlet ed -d //@id -d //@class -d //@rel -d //@style -d //@target -d //_:br -r //_:u -v span \
| xmlstarlet sel -i -t -c '/_:html/_:body/node()' \
| sed -e 's/ xmlns="[^[:space:]]*"//g' \
| kramdown -i html -o remove_html_tags,kramdown --line-width 9999 --remove-span-html-tags
```


## License

Copyright 2016–2020 Christopher Brown.
[MIT Licensed](https://chbrown.github.io/licenses/MIT/#2016-2020).
