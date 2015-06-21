'use strict';

import React from 'react/addons';
import request from 'superagent';
import PostInfo from './PostInfo';
import DisqusThread from 'react-disqus-thread';

export default class Post extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  get resourceUrl() {
    return `/api/posts/${this.props.params.slug}.json`;
  }

  componentDidMount() {
    request.
      get(this.resourceUrl).
      end(this.callback.bind(this));
  }

  callback(error, response) {
    this.setState(response.body);
  }

  render() {
    return (
      <div>
        <h1>{this.state.title}</h1>
        <PostInfo data={this.state} />
        <span dangerouslySetInnerHTML={{__html: this.state.body}} />
        <DisqusThread shortname="paypertask" />
      </div>
    );
  }
}
