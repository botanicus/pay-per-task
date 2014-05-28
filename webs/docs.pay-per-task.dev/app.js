var app = angular.module('app', ['ngSanitize', 'btford.markdown']);

app.config(function($sceDelegateProvider) {
  $sceDelegateProvider.resourceUrlWhitelist([
    'http://raw.pay-per-task.dev/**'
  ]);
});

/* Highlight.js */
// hljs.configure({classPrefix: ''});
// hljs.initHighlightingOnLoad();

/* Main controller. */
app.controller('MainController', function ($scope, $location) {
  var domain = 'http://raw.pay-per-task.dev';
  var pathname = window.location.pathname;
  var path = pathname.replace(/\/$/, '/README.md');
  console.log($scope.rawReadmeURL = domain + path);
  setTimeout(function () { // We could retrieve it manually and use the success callback.
    var collection = document.querySelectorAll('pre > code[class]');
    [].forEach.call(collection, function (block) {
      var highlighted = hljs.highlight(block.className, block.innerHTML);
      block.innerHTML = highlighted.value;
    });

    // Highlight TODOs.
    $('p:contains("TODO")').css('background-color', 'yellow');
  }, 100);
});
