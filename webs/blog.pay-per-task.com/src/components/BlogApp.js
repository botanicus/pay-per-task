'use strict';

import {Router, RouteHandler} from 'react-router';
import GoogleAnalytics from 'react-g-analytics';

import {React, Component} from './Component';
import Link from './Link';

// CSS
import 'bootstrap/dist/css/bootstrap.css';
import '../styles/main.css';

// Metadata
import metadata from 'data/metadata.json';

export default class BlogApp extends Component {
  get metadata() {
    return metadata;
  }

  render() {
    return (
      <div className='main'>
        {super.render()}

        <h1><Link to="/">{this.title}</Link></h1>
        <RouteHandler metadata={this.metadata} />
        <GoogleAnalytics id="UA-51610302-2" />
      </div>
    );
  }
}

// var imageURL = require('../images/yeoman.png');
// <img src={imageURL} />
