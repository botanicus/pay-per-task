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

// module.directive('dropdown', function () {
//   return {
//     link: function (scope, element, attrs) {
//       element.on('click', function () {
//         (attrs.isToggled == undefined) ? attrs.isToggled = false : attrs.isToggled = !attrs.isToggled;

//         if (!attrs.menu) {
//           throw("You have to provide menu attribute with value of ID of the menu you want to show.");
//         };

//         var menu = document.getElementById(attrs.menu);

//         if (!menu) {
//           throw("There's no element with ID " + attrs.menu);
//         };

//         if (attrs.isToggled) {
//           menu.style.display = 'none';
//         } else {
//           menu.style.display = 'block';
//         }
//       });
//     }
//   };
// });
