#!/usr/bin/env node

var http = require('http');
var amqp = require('amqplib');
var q = require('q'); // http://old.erickrdch.com/2012/06/how-to-wait-for-2-asynchronous-responses-on-nodejs-commonjs-promises.html

// amqp.connect('amqp://localhost', function (error, connection) {
//   if (error != null) {
//     console.error(error);
//     process.exit(1);
//   };
//   console.log(connection)

//   var channelPromise = connection.createChannel();

  // TODO: Limit size as documented here:
  // http://stackoverflow.com/questions/18931452/node-js-get-path-from-the-request
  var server = http.createServer(function (request, response) {
    console.log("~", request.method, request.url);

    if (request.method == 'POST' && request.url.match(/^\/(pt|jira)\/(.+)\/(.+)$/)) {
      var body = '';
      request.on('data', function (chunk) {
        body += chunk;
      });

      request.on('end', function () {
        console.log("~ POST data:", body);
        channelPromise.then(function (channel) {
          channel.sendToQueue('ppt.in', new Buffer(body));
        });
      });
    } else if (request.method == 'GET' && request.url == '/ping') {
      console.log("~> HTTP 200 OK");
      response.writeHead(200, {'Content-Type': 'text/plain'});
      response.end("Pong!\n");
    } else {
      response.writeHead(400, {'Content-Type': 'text/plain'});
      console.log("~> HTTP 400 Bad Request");
      response.end("Request has to be POST /[pt|jira]/:username/:key!\n");
    };
  });

  server.listen(7000);

  server.on('listening', function () {
    console.log("~ Yes, sir, I'm listening on port 7000!");
  });
// });
