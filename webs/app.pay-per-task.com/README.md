# About

The app runs on [app.pay-per-task.dev](http://app.pay-per-task.dev). It requires the API server to run.

## Setup

Bower packages are part of the container, but not part of the repository, so you need to run `bower install` in `content/` (where the `bower.json` file is).

# How The App Is Structured?

Regardless of where you go, `app.html` is always served. Yo go to `/`, you get `app.html`. You go to `/pricing` and again, you get `app.html`.

Basically `app.html` works as a layout. In it there's: `<div ng-view>Loading ...</div>` This code triggers angular routing and replaces what is in the div by one of the templates in `templates/`.
