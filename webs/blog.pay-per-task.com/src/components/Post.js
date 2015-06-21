'use strict';

import React from 'react/addons';
import request from 'superagent';
import PostInfo from './PostInfo';
import DisqusThread from 'react-disqus-thread';
import Head from 'react-helmet';

export default class Post extends React.Component {
  constructor(props) {
    super(props);
    this.state = {tags: []};
  }

  get meta() {
    return [];
  }

  get links() {
    return this.state.tags.map((tag) => (
      {rel: 'alternate', title: tag.title, href: tag.feed}
    ));
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
        <Head
          title={this.state.title}
          meta={this.meta}
          link={this.links}
        />

        <h1>{this.state.title}</h1>
        <PostInfo data={this.state} />
        <span dangerouslySetInnerHTML={{__html: this.state.body}} />
        <DisqusThread shortname="paypertask" />
      </div>
    );
  }
}
