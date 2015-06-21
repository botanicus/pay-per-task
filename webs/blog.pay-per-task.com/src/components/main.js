'use strict';

import React from 'react';
import Router from 'react-router';
var Route = Router.Route;

import BlogApp from './BlogApp';
import PostsList from './PostsList';
import Post from './Post';

// Router.
var Routes = (
  <Route handler={BlogApp}>
    <Route path="/" handler={PostsList} />
    <Route path="/posts/:slug" handler={Post} />
  </Route>
);

var content = document.getElementById('content');

Router.run(Routes, function (Handler) {
  React.render(<Handler />, content);
});
