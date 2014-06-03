var app = angular.module('app', ['ui.router', 'ngSanitize', 'services']);

app.config(function ($stateProvider, $urlRouterProvider, $locationProvider, $sceDelegateProvider) {
  $urlRouterProvider.otherwise('/');

  $stateProvider
    // This uses the default title.
    .state('posts', {
      url: '/',
      templateUrl: '/templates/posts.html',
      resolve: {
        posts: function (Post) {
          return Post.query().$promise;
        }
      },
      controller: function ($scope, posts) {
        $scope.posts = posts;
      }
    })

    .state('post', {
      url: '/posts/:slug', // update URL later
      templateUrl: '/templates/post.html',
      resolve: {
        post: function ($stateParams, Post) {
          return Post.get({slug: $stateParams.slug});
        }
      },
      controller: function ($rootScope, $scope, post) {
        $rootScope.title = "Pay Per Task Blog: " + post.title;
        $scope.post = post;
      }
    })

    // .state('tags', {
    //   url: '/tags',
    //   title: 'Pay Per Task Blog: Tags'
    //   templateUrl: '/templates/tags.html'
    // })

    .state('tag', {
      url: '/tags/:name',
      templateUrl: '/templates/tag.html',
      resolve: {
        tag: function ($stateParams, Tag) {
          return Tag.get({name: $stateParams.name});
        }
      },
      controller: function ($rootScope, $scope, tag) {
        $rootScope.title = "Pay Per Task Blog: " + tag.title + " tag";
        $scope.tag = tag;
      }
    });

  $locationProvider.html5Mode(true);

  $sceDelegateProvider.resourceUrlWhitelist(['self']);
});

/* Set up the title. */
app.run(function($location, $rootScope) {
  $rootScope.$on('$stateChangeSuccess', function (event, state, params) {
    $rootScope.title = state.title ? state.title : null;
  });
});

/* Main controller. */
app.controller('MainController', function ($scope, Post) {
  //
});

/* Directives. */
app.directive('page', function ($rootScope, $location) {
  return {
    restrict: 'E',
    scope: true,
    transclude: true,
    template: '<a ng-hide="isCurrent" href="{{link}}"><span ng-transclude></span></a>  <span ng-show="isCurrent"><span ng-transclude></span></span>',
    link: function (scope, element, attrs) {
      scope.link = attrs.link;
      scope.text = element.html();

      $rootScope.$on('$routeChangeStart', function () {
        scope.isCurrent = ($location.path() === attrs.link);
      });
    }
  };
});
