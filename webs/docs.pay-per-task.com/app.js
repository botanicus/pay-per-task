var app = angular.module('app', ['ngSanitize', 'btford.markdown']);

app.config(function($sceDelegateProvider) {
  $sceDelegateProvider.resourceUrlWhitelist([
    'http://raw.pay-per-task.dev/**'
  ]);
});

/* Main controller. */
app.controller('MainController', function ($scope, $location) {
  var domain = 'http://raw.pay-per-task.dev';
  var pathname = window.location.pathname;
  var path = pathname.replace(/\/$/, '/README.md');
  $scope.rawReadmePath = path.replace(/^\//, '');
  console.log($scope.rawReadmeURL = domain + path);

  /* Syntax highlighting http://highlightjs.org/usage. */

  // We could retrieve it manually and use the success callback.
  setTimeout(function () {
    var collection = document.querySelectorAll('pre > code[class]');
    [].forEach.call(collection, function (block) {
      var highlighted = hljs.highlight(block.className, block.innerHTML);
      block.innerHTML = highlighted.value;
    });

    /* Highlight TODOs. */
    $('p:contains("TODO")').css('background-color', 'yellow');
  }, 100);
});
