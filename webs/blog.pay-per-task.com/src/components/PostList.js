'use strict';

import {React, Component} from './Component';
import PostPreview from './PostPreview';
import request from 'superagent';
import Head from 'react-helmet';

export default class PostList extends Component {
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

    return (
      <div>
        {super.render()}

        <div className="posts">
          {nodes}
        </div>
      </div>
    );
  }
}
