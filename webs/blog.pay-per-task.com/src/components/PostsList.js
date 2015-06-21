'use strict';

import React from 'react/addons';
import PostPreview from './PostPreview';
import request from 'superagent';

export default class PostsList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {posts: []};
  }

  get resourceUrl() {
    return '/api/posts.json';
  }

  componentDidMount() {
    request.
      get(this.resourceUrl).
      end(this.callback.bind(this));
  }

  callback(error, response) {
    this.setState({posts: response.body});
  }

  render() {
    var nodes = this.state.posts.map(post =>
      <PostPreview data={post} />
    );

    return <div>{nodes}</div>;
  }
}
