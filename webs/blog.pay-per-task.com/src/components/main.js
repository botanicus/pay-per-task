'use strict';

import React from 'react';
import Router from 'react-router';
var Route = Router.Route;

import BlogApp from './BlogApp';
import PostsList from './PostsList';
import Post from './Post';
import Tag from './Tag';

// Router.
var Routes = (
  <Route handler={BlogApp}>
    <Route name="/" handler={PostsList} />
    <Route name="post" path="/posts/:slug" handler={Post} />
    <Route name="tag" path="/tags/:slug" handler={Tag} />
  </Route>
);

var content = document.getElementById('content');

Router.run(
  Routes,
  Router.HistoryLocation, // HTML 5 routes.
  (Handler) => React.render(<Handler />, content)
);
