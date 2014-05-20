# Setup

```
cd webs/presentation-web
bundle install
./config.ru
```

# Development

To install JS/CSS frameworks and their plugins, use [Bower.io](http://bower.io)

First, install bower:

```
homebrew install node
npm install -g bower
```

Then use it:

```
bower install angular#1.3
```

# How The App Is Structured?

Regardless of where you go, `app.html` is always served. Yo go to `/`, you get `app.html`. You go to `/pricing` and again, you get `app.html`.

Basically `app.html` works as a layout. In it there's: `<div ng-view>Loading ...</div>` This code triggers angular routing and replaces what is in the div by one of the templates in `templates/`.

Simple as that.
