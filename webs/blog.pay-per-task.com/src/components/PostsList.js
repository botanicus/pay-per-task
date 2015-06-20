'use strict';

import React from 'react/addons';
import PostPreview from './PostPreview';
import request from 'superagent';

class PostsList extends React.Component {
  constructor(state) {
    super(state);
    this.state = {posts: []};
  }

  postsCallback(error, response) {
    this.setState({posts: response.body});
  }

  componentDidMount() {
    request.
      get(this.props.url).
      end(this.postsCallback.bind(this));
  }

  render() {
    var nodes = this.state.posts.map(post =>
      <PostPreview data={post}>
        {post.excerpt}
      </PostPreview>
    );

    return <div>{nodes}</div>;
  }
}

module.exports = PostsList;
