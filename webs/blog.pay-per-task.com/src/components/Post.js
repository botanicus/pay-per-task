'use strict';

import React from 'react/addons';
import request from 'superagent';

class Post extends React.Component {
  constructor(state) {
    super(state);
    this.state = {};
  }

  get postUrl() {
    return '/api/posts/' + this.props.params.slug + '.json';
  }

  componentDidMount() {
    request.
      get(this.postUrl).
      end(this.postCallback.bind(this));
  }

  postCallback(error, response) {
    this.setState(response.body);
  }

  render() {
    return (
      <div>
        <h1>{this.state.title}</h1>
        {this.state.excerpt}
        <span dangerouslySetInnerHTML={{__html: this.state.body}} />
      </div>
    );
  }
}

module.exports = Post;
