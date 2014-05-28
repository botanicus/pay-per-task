var app = angular.module('app', ['ngRoute', 'ui.bootstrap', 'ngAnimate', 'notifications']);

app.config(function ($locationProvider, $routeProvider) {
  $routeProvider.
    when('/', {
      templateUrl: 'templates/business-owners.html',
      title: "PPT: The secret weapon in MOTIVATING your IT team!"
    }).

    when('/sign-up', {
      templateUrl: 'templates/sign-up.html',
      title: "PPT: Sign up now!",
      controller: 'SignUpController'
    }).

    otherwise({'redirectTo': '/'});

  $locationProvider.html5Mode(true);
});

/* Set up the title. */
app.run(function($location, $rootScope) {
  $rootScope.$on('$routeChangeSuccess', function (event, current, previous) {
    $rootScope.title = current.$$route ? current.$$route.title : null;
  });
});

/* Main controller. */
app.controller('MainController', function ($scope, Notifications) {
  Notifications.register($scope);
});
