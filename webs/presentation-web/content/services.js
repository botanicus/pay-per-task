var services = angular.module('services', []);

services.factory('Links', function ($location) {
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

services.factory('currentUser', function () {
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
