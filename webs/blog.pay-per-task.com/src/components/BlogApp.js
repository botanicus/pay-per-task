'use strict';

import React from 'react/addons';
import PostList from './PostList';
import {Router, RouteHandler} from 'react-router';
import GoogleAnalytics from 'react-g-analytics';
import Head from 'react-helmet';

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

  get meta() {
    return [
      {name: 'description', content: this.state.title},
      {property: 'og:type', content: 'article'}
    ];
  }

  get links() {
    return [
      {rel: 'canonical', href: this.state.base_url},
      {rel: 'alternate', title: this.state.title, href: this.state.feed}
      // {rel: 'apple-touch-icon', href: 'http://mysite.com/img/apple-touch-icon-57x57.png'},
      // {rel: 'apple-touch-icon', sizes: '72x72', href: 'http://mysite.com/img/apple-touch-icon-72x72.png'}
    ];
  }

  render() {
    return (
      <div className='main'>
        <Head
          title={this.state.title}
          meta={this.meta}
          link={this.links}
        />

        <h1><Link to="/">{this.state.title}</Link></h1>
        <RouteHandler metadata={this.state} />
        <GoogleAnalytics id="UA-51610302-2" />
      </div>
    );
  }
}

// var imageURL = require('../images/yeoman.png');
// <img src={imageURL} />
