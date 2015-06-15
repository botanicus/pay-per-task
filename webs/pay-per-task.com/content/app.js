var app = angular.module('app', ['ngRoute', 'ngCookies', 'ui.bootstrap', 'ngAnimate', 'notifications', 'services', 'directives']);

app.config(function ($locationProvider, $routeProvider, $httpProvider) {
  window.routes.forEach(function (route) {
    $routeProvider.when(route.path, route);
  });

  $routeProvider.otherwise({'redirectTo': '/'});

  $locationProvider.html5Mode(true);

  // Transmit cookies.
  // As far as I know, we can't read those cookies
  // which the server sets in the response, but those
  // are being set properly, so the login works.
  $httpProvider.defaults.withCredentials = true;
});

app.run(function ($rootScope, $window, $location, Session) {
  Session.development = true;

  // Set up Google Analytics.
  // TODO: Not hosted within MY account, but rather under info@pay-per-task.com.
  if ($location.host() == 'pay-per-task.com' && $window.ga) {
    $window.ga('create', 'UA-51610302-1');
    $rootScope.$on('$routeChangeSuccess', function () {
      $window.ga('send', 'pageview', $location.path());
    });
  }

  /* Set up the title. */
  $rootScope.$on('$routeChangeSuccess', function (event, current, previous) {
    $rootScope.title = current.$$route ? current.$$route.title : null;
  });
});

/* Main controller. */
app.controller('MainController', function ($scope, $window, $location, $http, $modal, Links, Session, currentUser, $cookies) {
  $scope.$on('$viewContentLoaded', function (event) {
    if (Session.development && $window.ga) {
      console.log("~ Triggering Google Analytics.");
      $window.ga('send', 'pageview', {page: $location.path()});
    };
  });

  $scope.year = new Date().getFullYear();

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
app.controller('NewsletterController', function ($scope, $http, Notifications) {
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

app.controller('OnboardingController', function ($scope, $http, $routeParams) {
  $scope.register = function () {
    var data = {plan: $routeParams.plan, token: $scope.token, service: 'pt'};
    $http.post('http://api.pay-per-task.dev/users', data).
      success(function (data, status, headers) {
        $scope.user = data;
        console.log(data)
        // This should log the user in.
      }).
      error(function (error) {
        console.log(data)
      });
  };

  $scope.installToProject = function (projectId) {
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

app.controller('NavbarController', function ($scope, $document) {
  $scope.isCollapsed = true;

  $scope.$on('$routeChangeSuccess', function ($location, $routeParams) {
    var windowPath = window.location.pathname;
    var navBarLi = document.querySelectorAll(".navbar-nav li");
    var currentLink = document.querySelector(".navbar-nav li a[href='" + windowPath + "']");

    for(var i = 0; i < navBarLi.length; i++) {
      navBarLi[i].classList.remove('active');
    }

    currentLink.parentElement.classList.add('active');

    $scope.isCollapsed = true;
  });
});
