# About

_Extracted from [pay-per-task.com](http://pay-per-task.com/contractors). Do you work as a contractor? Imagine how awesome would it be to be paid instantaneously for every task you finish and without dealing with those pesky invoices? Check [pay-per-task.com](http://pay-per-task.com/contractors) out now!_

TODO

# Features

- Highlights any paragraph containing the word 'TODO'.

# Installation

```
# Assuming you're in the top-level repository:
bower install botanicus/doxxu
```

## Nginx Vhost

Doxxu is just a very simple AngularJS app, you can serve it with anything you want. Let's use Nginx for our example:

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

# TODO

- I want to be able to use ng-include
<div ng-include="/source/webs/api.pay-per-task.com/puma.config.rb">
</div>
- Integrate subl:// to open files.
- Instead of using two subdomains, use just one. Code shall live on `/source/:path`. By doing so we can also eliminate the SCE whitelist.
- Come up with production settings (authentication etc).
- Make it OSS.
- Make it installable through Bower?
- Add it as a submodule OR install through Bower.
- Handling non-existing files like http://docs.pay-per-task.dev/docs/i-do-not-exist.md
