exports.__defineGetter__('view', function () {
  return $('[ng-view]');
});

exports.__defineGetter__('viewText', function () {
  return $('[ng-view]').getText();
});

exports.__defineGetter__('ptor', function () {
  return protractor.getInstance();
});

exports.elementExists = function (selector) {
  expect(exports.ptor.isElementPresent($(selector))).toBe(true);
};
