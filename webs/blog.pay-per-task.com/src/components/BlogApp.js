'use strict';

import React from 'react/addons';
import request from 'superagent';
import PostsList from './PostsList';
import Router from 'react-router';

// CSS
require('normalize.css');
require('../styles/main.css');

var metadata = require('data/metadata.json');

class BlogApp extends React.Component {
  constructor(state) {
    super(state);
    this.state = metadata;
  }

  render() {
    return (
      <div className='main'>
        <h1>{this.state.title}</h1>
        <Router.RouteHandler />
      </div>
    );
  }
}

// var imageURL = require('../images/yeoman.png');
// <img src={imageURL} />

module.exports = BlogApp;
