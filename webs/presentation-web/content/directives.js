var module = angular.module('directives', []);

module.directive('message', function () {
  return {
    restrict: 'E',
    link: function (scope, element, attrs) {
      element[0].style.display = 'none';
      if (!scope.$parent.messages) scope.$parent.messages = {};
      scope.$parent.messages[attrs.type] = element.html();
    }
  }
});

module.directive('page', function ($rootScope, $location) {
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
