var services = angular.module('services', ['ngResource']);

services.constant('Session', {
  development: (window.location.host == 'blog.pay-per-task.dev')
});

services.factory('Post', function ($resource) {
  return $resource('/api/posts/:slug.json');
});

services.factory('Tag', function ($resource) {
  return $resource('/api/tags/:name.json');
});


services.constant('routes', {
  api: {
    stats: '/stats',
    users: '/users',
  }
});

// Convenience method for Links.users and such.
services.factory('Links', function (routes) {
  var helper = {};

  Object.keys(routes).forEach(function (namedPath) {
    helper.__defineGetter__(namedPath, function () {
      return routes[namedPath];
    });
  });

  return helper;
});
