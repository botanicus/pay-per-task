'use strict';

import React from 'react/addons';
import request from 'superagent';
import PostInfo from './PostInfo';

class Post extends React.Component {
  constructor(props) {
    super(props);
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
        <PostInfo data={this.state} />
        <span dangerouslySetInnerHTML={{__html: this.state.body}} />
      </div>
    );
  }
}

module.exports = Post;
