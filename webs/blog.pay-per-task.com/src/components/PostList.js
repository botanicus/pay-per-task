'use strict';

import React from 'react/addons';
import PostPreview from './PostPreview';
import request from 'superagent';
import Head from 'react-helmet';

export default class PostList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {posts: []};
  }

  get meta() {
    return [];
  }

  get links() {
    return [];
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

    return (
      <div>
        <Head
          title={this.state.title}
          meta={this.meta}
          link={this.links}
        />

        <div className="posts">
          {nodes}
        </div>
      </div>
    );
  }
}
