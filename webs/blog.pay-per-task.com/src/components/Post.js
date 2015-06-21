'use strict';

import {React, Component} from './Component';
import request from 'superagent';
import PostInfo from './PostInfo';
import DisqusThread from 'react-disqus-thread';
import Head from 'react-helmet';

export default class Post extends Component {
  constructor(props) {
    super(props);
    this.state = {tags: []};
  }

  // get meta() {
  //   return [];
  // }

  get links() {
    var tagLinks = this.state.tags.map((tag) => (
      {rel: 'alternate', title: tag.title, href: tag.feed}
    ));

    return super.links.concat(tagLinks);
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
        {super.render()}

        <h1>{this.state.title}</h1>
        <PostInfo data={this.state} />
        <span dangerouslySetInnerHTML={{__html: this.state.body}} />
        <DisqusThread shortname="paypertask" />
      </div>
    );
  }
}
