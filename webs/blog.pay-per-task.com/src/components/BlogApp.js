'use strict';

import React from 'react/addons';
import PostList from './PostList';
import {Router, RouteHandler} from 'react-router';
import GoogleAnalytics from 'react-g-analytics';

import Link from './Link';

// CSS
import 'bootstrap/dist/css/bootstrap.css';
import '../styles/main.css';

// Metadata
import metadata from 'data/metadata.json';
// TODO: On top of this, use what's defined in https://github.com/rackt/react-router/issues/49

export default class BlogApp extends React.Component {
  constructor(props) {
    super(props);
    this.state = metadata;
  }

  componentDidMount() {
    document.title = this.state.title;
    var feeds = document.querySelectorAll('link[type="application/atom+xml"]');
    feeds = Array.prototype.slice.call(feeds, 0);
    feeds.forEach((feed) => document.head.removeChild(feed));
    var feed = document.createElement('link');
    feed.rel  = 'alternate';
    feed.type = 'application/atom+xml';
    feed.href = this.state.feed;
    feed.title = this.state.title;
    document.head.appendChild(feed);
  }

  render() {
    return (
      <div className='main'>
        <h1><Link to="/">{this.state.title}</Link></h1>
        <RouteHandler />
        <GoogleAnalytics id="UA-51610302-2" />
      </div>
    );
  }
}

// var imageURL = require('../images/yeoman.png');
// <img src={imageURL} />
