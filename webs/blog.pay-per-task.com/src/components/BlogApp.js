'use strict';

import React from 'react/addons';
import request from 'superagent';
import PostsList from './PostsList';

// CSS
require('normalize.css');
require('../styles/main.css');

var metadata = require('../../dist/api/metadata.json');

class BlogApp extends React.Component {
  constructor(state) {
    super(state);
    this.state = metadata;
  }

  render() {
    return (
      <div className='main'>
        <h1>{this.state.title}</h1>
        <PostsList url="/api/posts.json" />
      </div>
    );
  }
}

// var imageURL = require('../images/yeoman.png');
// <img src={imageURL} />

module.exports = BlogApp;
