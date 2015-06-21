'use strict';

import React from 'react/addons';
import request from 'superagent';
import PostPreview from './PostPreview';

class Tag extends React.Component {
  constructor(props) {
    super(props);
    this.state = {posts: []};
  }

  get tagUrl() {
    return '/api/tags/' + this.props.params.slug + '.json';
  }

  componentDidMount() {
    request.
      get(this.tagUrl).
      end(this.tagCallback.bind(this));
  }

  tagCallback(error, response) {
    this.setState({posts: response.body});
  }

  render() {
    var postPreviewNodes = this.state.posts.map((post) =>
      <PostPreview data={post} />)

    return <div>{postPreviewNodes}</div>;
  }
}

module.exports = Tag;
