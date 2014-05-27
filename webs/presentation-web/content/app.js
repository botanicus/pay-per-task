var app = angular.module('app', ['ngRoute', 'ngCookies', 'ui.bootstrap', 'ngAnimate', 'notifications', 'services', 'directives']);

app.config(function ($locationProvider, $routeProvider, $httpProvider) {
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

  // Transmit cookies.
  // As far as I know, we can't read those cookies
  // which the server sets in the response, but those
  // are being set properly, so the login works.
  $httpProvider.defaults.withCredentials = true;
});

/* Set up the title. */
app.run(function ($location, $rootScope, Session) {
  Session.development = true;

  $rootScope.$on('$routeChangeSuccess', function (event, current, previous) {
    $rootScope.title = current.$$route ? current.$$route.title : null;
  });
});

/* Main controller. */
app.controller('MainController', function ($scope, $window, $location, $http, $modal, Links, Session, currentUser, $cookies) {
  $scope.$on('$viewContentLoaded', function (event) {
    console.log("~ Triggering Google Analytics.");

    if (Session.development) {
      $window.ga('send', 'pageview', {page: $location.path()});
    };
  });

  $scope.displayLogInDialog = function () {
    $scope.modal = $modal.open({
      templateUrl: 'templates/login.html',
      controller: 'ModalController'
    });
  };

  // This is bullet-proof. Server could be down.
  // Subdomains MUST be used, however.
  $scope.logOut = function () {
    $cookies.session = ''
    delete $cookies.session;
    currentUser.reset();
  };

  $scope.Links = Links;

  // Try to log in.
  $scope.currentUser = currentUser;

  if ($cookies.session) {
    $http.get(Links.login).
      success(function (data, status, headers) {
        currentUser.init(data);
        console.log("~ Logged in", currentUser);
      }).
      error(function (error) {
        currentUser.reset();
        console.log("~ Not logged in.")
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

app.controller('ModalController', function ($scope, $modalInstance, Links, $window, $http) {
  $scope.close = function () {
    $modalInstance.close();
  };

  $scope.user = {};

  $scope.logIn = function () {
    $scope.authenticating = true;

    $http.post(Links.login, $scope.user).
      success(function () {
        $window.location = Links.profile;
      }).
      error(function (error) {
        $scope.authenticating = false;
        $scope.error = error;
      });
  };
});
