# About

<a href="https://raw.githubusercontent.com/botanicus/doxxu/master/docs.ppt.png">
  <img height="120" src="https://raw.githubusercontent.com/botanicus/doxxu/master/docs.ppt.png" />
</a>

_Doxxu has been extracted from [pay-per-task.com](http://pay-per-task.com/contractors). Do you work as a contractor? Do you want to be **paid instantaneously** for **every task** you finish and **without dealing with** those pesky **invoices**? Check [pay-per-task.com](http://pay-per-task.com/contractors) out now!_

Doxxu is a **documentation app**. Instead of coming with yet-another-supposedly cool wiki system or whatnot, doxxu leverages what is already **the standard** in writing documentation: **README files**. Those READMEs are linked together, for instance:

<ul>
  <li>README.md:</li>
  <ul>
    <li>Links consumers/README.md.</li>
    <li>Links webs/README.md:</li>
    <ul>
      <li>Links webs/pay-per-task.com/README.md.</li>
      <li>Links webs/api.pay-per-task.com/README.md</li>
    </ul>
    <li>Links docs/vagrant.md.</li>
  </ul>
</ul>

No rocket science, is it? But bloody hell, what more would you need?

## Why Should You Use Doxxu?

- Uses what already **works well: README files** written in [Markdown](http://daringfireball.net/projects/markdown/syntax) (using [Showdown](https://github.com/coreyti/showdown)).
- Everything stays in the **main git repository**, no mismatch between code and documentation versions<sup>[1]</sup>.
- Doxxu supports **syntax highlighting** using [Highlight.js](http://highlightjs.org/).
- It **highlights** any paragraph containing the word **'TODO'**.
- It's **super-easy to be run locally**. That has many advantages: you see changes immediately and you can use `subl://` URLs in order to open README files in Sublime Text<sup>[2]</sup>.

# Installation

Doxxu is super-simple, it's just a humble AngularJS app. Get it from Bower:

```bash
# Assuming you're in the top-level repository.
bower install botanicus/doxxu
```

## Nginx Vhost

Doxxu doesn't come with any command which would run a server, so you have to configure whatever server are you using. Let's use Nginx for our example:

```nginx
server {
  listen 80;
  server_name docs.pay-per-task.dev;


  location / {
    index app.html;
    root /webs/ppt/bower_components/doxxu;

    # This returns HTTP 200 on any
    # route and serves app.html.
    error_page 404 = /app.html;
  }

  location /source {
    alias /webs/ppt;

    # Serve it as plain text.
    default_type 'text/plain';
  }
}
```

That's it! Now you should be able to go to [docs.pay-per-task.dev](http://docs.pay-per-task.dev)<sup>[3]</sup> and be able to view the documentation.

# Possible Features For Next Versions

- Anchors (GitHub style?).
- Integrate `subl://` to open files. [[1](https://github.com/saetia/sublime-url-protocol-mac)], [[2](http://sublimetext.userecho.com/topic/97042-url-sheme-support-subletc/)]
- I want to be able to use something like `ng-include` to include configuration files without neccessarily copy & paste their content into the documentation like so:

```html
<!-- Include the current puma config. -->
<div ng-include="/source/webs/api.pay-per-task.com/puma.config.rb"></div>
```

- Linking images could be easier. We could use relative links, unfortunately there's the damn `/source/` right now.

```html
<!-- We're viewing http://docs.pay-per-task.dev/bower_components/doxxu/README.md -->
<a href="/source/bower_components/doxxu/docs.ppt.png">
  <img height="120" src="/source/bower_components/doxxu/docs.ppt.png" />
</a>
```

# Footnotes

- **[1]** Like with GitHub wiki which, as far as I understand, uses separate Git repository for the documentation.
- **[2]** Once I implement it :)
- **[3]** Or whatever your domain is.
