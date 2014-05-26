var services = angular.module('services', []);

services.factory('Session', function () {
  var session = {development: false};
  return session;
});

services.factory('Links', function (Session) {
  if (Session.development) {
    return {
      login: 'http://api.pay-per-task.dev/me',
      profile: 'http://app.pay-per-task.dev/profile'
    };
  } else {
    return {
      login: 'https://api.pay-per-task.com/me',
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
