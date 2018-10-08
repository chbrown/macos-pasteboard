# macos-pasteboard

Like OS X's built-in `pbpaste` but more flexible and raw.


## Install

```sh
git clone https://github.com/chbrown/macos-pasteboard
cd macos-pasteboard
make install
```


## Example

Highlight and copy the `macos-pasteboard` element in the preceding section.

```sh
pbv
```

> `macos-pasteboard`

```sh
pbv public.html
```

> `<meta charset='utf-8'><h1 style="box-sizing: border-box; font-size: 2em; margin-top: 0px !important; margin-right: 0px; margin-bottom: 16px; margin-left: 0px; font-weight: 600; line-height: 1.25; padding-bottom: 0.3em; border-bottom: 1px solid rgb(238, 238, 238); color: rgb(51, 51, 51); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Helvetica, Arial, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, &quot;Segoe UI Symbol&quot;; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px;">macos-pasteboard</h1>`

Using [tidy](http://www.html-tidy.org/),
[xmlstarlet](http://xmlstar.sourceforge.net/), and
[kramdown](https://kramdown.gettalong.org/),
we can convert this to markdown without too much pain:

```sh
pbv public.html \
| tidy -quiet --show-warnings no -asxml -i -w 0 --quote-nbsp no \
| xmlstarlet ed -d //@id -d //@class -d //@rel -d //@style -d //@target -d //_:br -r //_:u -v span \
| xmlstarlet sel -i -t -c '/_:html/_:body/node()' \
| sed -e 's/ xmlns="[^[:space:]]*"//g' \
| kramdown -i html -o remove_html_tags,kramdown --line-width 9999 --remove-span-html-tags
```


## License

Copyright 2016–2018 Christopher Brown.
[MIT Licensed](https://chbrown.github.io/licenses/MIT/#2016-2018).
