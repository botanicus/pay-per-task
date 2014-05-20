var app = angular.module('app', ['ngRoute']);

app.config(function ($locationProvider, $routeProvider) {
  $routeProvider.
    when('/', {
      templateUrl: 'templates/business-owners.html',
      title: "PPT: The secret weapon in MOTIVATING your IT team!"
    }).

    when('/contractors', {
      templateUrl: 'templates/contractors.html',
      title: "PPT: GET PAID for your work in REALTIME!"
    }).

    when('/pricing', {
      templateUrl: 'templates/pricing.html',
      title: "PPT: Pricing",
      controller: 'PricingController'
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
    $rootScope.title = current.$$route.title;
  });
});

/* Main controller. */
app.controller('MainController', function ($scope, $window, $location) {
  $scope.$on('$viewContentLoaded', function(event) {
    console.log("~ Triggering Google Analytics.");

    if (!window.location.host.match('localhost')) {
      $window.ga('send', 'pageview', {page: $location.path()});
    };
  });
});

/* Per-page controllers */
app.controller('PricingController', function ($scope) {
  // TODO
});

app.controller('SignUpController', function ($scope) {
  // TODO
});
