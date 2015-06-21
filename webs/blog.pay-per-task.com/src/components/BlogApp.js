'use strict';

import React from 'react/addons';
import request from 'superagent';
import PostsList from './PostsList';
import {Router, RouteHandler} from 'react-router';
import GoogleAnalytics from 'react-g-analytics';

import Link from './Link';

// CSS
import 'bootstrap/dist/css/bootstrap.css';
import '../styles/main.css';

// Metadata
import metadata from 'data/metadata.json';
if (document) { document.title = metadata.title; }

export default class BlogApp extends React.Component {
  constructor(props) {
    super(props);
    this.state = metadata;
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
