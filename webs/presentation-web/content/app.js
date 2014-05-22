var app = angular.module('app', ['ngRoute', 'ngCookies', 'ui.bootstrap', 'ngAnimate', 'notifications']);

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

    when('/about-us', {
      templateUrl: 'templates/about-us.html',
      title: "PPT: About Us"
    }).

    when('/pricing', {
      templateUrl: 'templates/pricing.html',
      title: "PPT: Pricing"
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
app.run(function ($location, $rootScope) {
  $rootScope.$on('$routeChangeSuccess', function (event, current, previous) {
    $rootScope.title = current.$$route.title;
  });
});

/* Main controller. */
app.controller('MainController', function ($scope, $window, $location, $cookies, $http, $modal) {
  $scope.$on('$viewContentLoaded', function(event) {
    console.log("~ Triggering Google Analytics.");

    if (!window.location.host.match('localhost')) {
      $window.ga('send', 'pageview', {page: $location.path()});
    };
  });

  var email = $cookies.email;
  if (email) {
    console.log("~ Trying to log in as " + email);
    $scope.user = $http.post('http://app.pay-per-task.com/me', {email: email});
  };

  $scope.displayLogInDialog = function () {
    $scope.modal = $modal.open({
      templateUrl: 'templates/login.html',
      controller: 'ModalController'
    });
  };
});

/* Per-page controllers */
app.controller('SignUpController', function ($scope, $http, Notifications) {
  Notifications.register($scope);

  $scope.subscribe = function () {

    if ($scope.subscriptionForm.$valid) {
      console.log("~ Subscribing " + $scope.email);

      $http.post('/subscribe', {email: $scope.email}).
        success(function (data, status, headers, config) {
          var message = $scope.messages.success;
          Notifications.list.create(message, {type: 'success'});
        }).

        error(function (data, status, headers, config) {
          var message = $scope.messages.error;
          Notifications.list.create(message, {type: 'error'});
        });
    } else {
      // This shouldn't occur unless HTML 5 validations are not supported.
      console.log("~ Form is invalid!");
    }
  };
});

app.controller('ModalController', function ($scope, $modalInstance, $cookies, $window) {
  $scope.email = $scookies.email;

  $scope.close = function () {
    $modalInstance.close();
  };

  $scope.logIn = function () {
    $scope.authenticating = true;

    $http.post('http://app.pay-per-task.com/me', {email: email}).
      success(function () {
        $window.location = 'http://app.pay-per-task.com';
      }).
      error(function (error) {
        $scope.authenticating = false;
        $scope.error = error;
      });
  };
});

app.directive('message', function () {
  return {
    restrict: 'E',
    link: function (scope, element, attrs) {
      element[0].style.display = 'none';
      if (!scope.$parent.messages) scope.$parent.messages = {};
      scope.$parent.messages[attrs.type] = element.html();
    }
  }
});
