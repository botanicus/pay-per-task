/*                  */
/* notifications.js */
/*                  */

var service = Object.create({logging: false, timeout: 3500});

/* Helpers */
service.log = function () {
  if (service.logging) {
    var slice = Array.prototype.slice;
    var args  = slice.call(arguments, service.log.length);
    console.log(args);
  };
};


/* Notification class */
var Notification = function (message, options) {
  this.message = message;
  this.options = options || {};

  this.options.__proto__ = Notification.defaultOptions;
};

service.Notification = Notification;

Notification.defaultOptions = {type: 'success', sticky: false};

// This should have no knowledge of service.list,
// but since this is going to be called from a view,
// let's choose convenience and view readability over
// proper encapsulation.
Notification.prototype.remove = function () {
  service.list.remove(this);
};


/* NotificationList class */
var NotificationList = function () {
  this.collection = [];
};

service.NotificationList = NotificationList;
service.list = new NotificationList();

/* NotificationList public API */
NotificationList.prototype.create = function (message, options) {
  var notification = new Notification(message, options);
  this.collection.push(notification);
  this.broadcast();
  if (!notification.options.sticky) this.registerTimeout(notification);
  return notification;
};

NotificationList.prototype.remove = function (notification) {
  var index = this.collection.indexOf(notification);

  if (index > -1) {
    this.collection.splice(index, 1);
  };

  this.broadcast();

  return this;
};

/* NotificationList private API */
NotificationList.prototype.broadcast = function () {};

NotificationList.prototype.registerTimeout = function (notification) {
  if (notification.options.sticky) {
    throw new Error("Notification is sticky!");
  };

  service.log("Temporary notification '" + notification.message + "' scheduled to be deleted.")

  var notificationList = this;
  setTimeout(function () { notificationList.remove(notification) }, service.timeout);
};


/*                          */
/* angular-notifications.js */
/*                          */

var module = angular.module('notifications', []);

// Read discussion under http://kirkbushell.me/when-to-use-directives-controllers-or-services-in-angular/
// it's unclear whether we should use service or factory.
module.service('Notifications', function ($rootScope, $timeout) {

  /* Hooks */
  service.register = function (scope) {
    scope.$on('notifications.update', function (event) {
      service.log("Notifications updated:", scope.notifications);
      if (scope.$$phase != '$apply') scope.$apply();
    });

    scope.notifications = service.list.collection;
  };

  service.NotificationList.prototype.broadcast = function () {
    $rootScope.$broadcast('notifications.update');
  };

  return service;
});
