'use strict';

import BlogApp from './BlogApp';
import React from 'react';
import Router from 'react-router';
var Route = Router.Route;

// Router.
var Routes = (
  <Route handler={BlogApp}>
    <Route name="/" handler={BlogApp} />
  </Route>
);

var content = document.getElementById('content');

Router.run(Routes, function (Handler) {
  React.render(<Handler/>, content);
});
