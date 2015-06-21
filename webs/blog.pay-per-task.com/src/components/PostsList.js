'use strict';

import React from 'react/addons';
import PostPreview from './PostPreview';
import request from 'superagent';

class PostsList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {posts: []};
  }

  postsCallback(error, response) {
    this.setState({posts: response.body});
  }

  componentDidMount() {
    request.
      get('/api/posts.json').
      end(this.postsCallback.bind(this));
  }

  render() {
    var nodes = this.state.posts.map(post =>
      <PostPreview data={post} />
    );

    return <div>{nodes}</div>;
  }
}

module.exports = PostsList;
