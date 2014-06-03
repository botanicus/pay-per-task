var app = angular.module('app', ['ngSanitize']);

/* Main controller. */
app.controller('MainController', function ($scope, $location, $http) {
  var domain = 'http://docs.pay-per-task.dev/source';
  var pathname = window.location.pathname;
  /*
  We could use the following in our Nginx vhost:

  location /source {
    index README.md;
  }

  The thing is, by that we wouldn't know the actual
  path of the file which we are showing as a subtitle.
  */
  var path = pathname.replace(/\/$/, '/README.md');
  $scope.rawReadmePath = path.replace(/^\//, '');
  $scope.rawReadmeURL = domain + path;

  $http.get($scope.rawReadmeURL).success(function (data) {
    var readme = document.getElementById('readme');
    var converter = new Showdown.converter();
    readme.innerHTML = converter.makeHtml(data);

    /* Syntax highlighting http://highlightjs.org/usage. */
    var collection = document.querySelectorAll('pre > code[class]');
    [].forEach.call(collection, function (block) {
      var highlighted = hljs.highlight(block.className, block.innerText);
      block.innerHTML = highlighted.value;
    });

    $('p:contains("TODO")').css('background-color', 'yellow');
  });

});

