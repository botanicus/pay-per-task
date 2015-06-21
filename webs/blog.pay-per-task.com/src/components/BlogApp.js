'use strict';

import React from 'react/addons';
import request from 'superagent';
import PostsList from './PostsList';
import {Router, RouteHandler, Link} from 'react-router';

// CSS
require('normalize.css');
require('../styles/main.css');

var metadata = require('data/metadata.json');

class BlogApp extends React.Component {
  constructor(props) {
    super(props);
    this.state = metadata;
  }

  render() {
    return (
      <div className='main'>
        <h1><Link to="/">{this.state.title}</Link></h1>
        <RouteHandler />
      </div>
    );
  }
}

// var imageURL = require('../images/yeoman.png');
// <img src={imageURL} />

module.exports = BlogApp;
