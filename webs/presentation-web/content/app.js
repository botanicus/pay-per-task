var app = angular.module('app', ['ngRoute', 'ui.bootstrap', 'ngAnimate', 'notifications']);

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
      title: "PPT: Pricing"
    }).

    when('/about-us', {
      templateUrl: 'templates/about-us.html',
      title: "PPT: About Us"
    }).

    when('/contact', {
      templateUrl: 'templates/contact.html',
      title: "PPT: Contact"
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

/* Services. */
app.factory('Links', function ($location) {
  if ($location.host() == 'localhost') {
    return {
      login: 'http://localhost:4002/me',
      profile: 'http://localhost:4002/profile'
    };
  } else {
    return {
      login: 'https://app.pay-per-task.com/me',
      profile: 'https://app.pay-per-task.com/profile'
    }
  }
});

app.factory('currentUser', function () {
  var user = {loggedIn: false};

  user.init = function (data) {
    this.loggedIn = true;
    user.__proto__ = data;
  };

  user.reset = function () {
    this.loggedIn = false;
    user.__proto__ = {};
  };

  return user;
});

/* Main controller. */
app.controller('MainController', function ($scope, $window, $location, $http, $modal, Links, currentUser) {
  $scope.$on('$viewContentLoaded', function(event) {
    console.log("~ Triggering Google Analytics.");

    if ($location.host() != 'localhost') {
      $window.ga('send', 'pageview', {page: $location.path()});
    };
  });

  $scope.displayLogInDialog = function () {
    $scope.modal = $modal.open({
      templateUrl: 'templates/login.html',
      controller: 'ModalController'
    });
  };

  $scope.Links = Links;

  // Try to log in.
  $scope.currentUser = currentUser;

  $http.get(Links.login).
    success(function (data) {
      currentUser.init(data);
      console.log("~ Logged in", currentUser);
      window.u = currentUser;
    }).
    error(function (error) {
      currentUser.reset();
      console.log("~ Not logged in.")
    });
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

app.controller('ModalController', function ($scope, $modalInstance, Links, $window, $http) {
  $scope.close = function () {
    $modalInstance.close();
  };

  // $scope.logIn = function () {
  //   $scope.authenticating = true;

  //   $http.post(Links.login, {email: email}).
  //     success(function () {
  //       $window.location = 'http://app.pay-per-task.com';
  //     }).
  //     error(function (error) {
  //       $scope.authenticating = false;
  //       $scope.error = error;
  //     });
  // };
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

app.directive('page', function ($rootScope, $location) {
  return {
    restrict: 'E',
    scope: true,
    transclude: true,
    template: '<a ng-hide="isCurrent" href="{{link}}"><div ng-transclude></div></a>  <span ng-show="isCurrent"><div ng-transclude></div></span>',
    link: function (scope, element, attrs) {
      scope.link = attrs.link;
      scope.text = element.html();

      $rootScope.$on('$routeChangeStart', function () {
        scope.isCurrent = ($location.path() === attrs.link);
      });
    }
  };
});
