var h = require('../helpers.js');

describe('Landing page for business owners', function () {
  beforeEach(function () {
    browser.get('/');
  });

  it('displays the copy for business owners', function () {
    expect(h.viewText).toMatch(
      'You CANNOT possibly motivate anyone by giving them a list of tasks and a fixed rate!'
    );
  });

  it('has a switch to the contractors landing page', function () {
    expect($('a[href="/contractors"]').getText()).toEqual('Contractor? CLICK HERE!');
  });

  it('has a call to action button', function () {
    expect($('[ng-view] a.btn[href="/pricing"]').getText()).toEqual('Get it NOW!');
  });
});
