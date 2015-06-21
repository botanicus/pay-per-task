'use strict';

import PostList from './PostList';

export default class Tag extends PostList {
  // FIXME: The feeds wouln't rerender when we change to a different tag.
  get links() {
    var tag = this.state.tag || {};
    return [
      {rel: 'alternate', title: tag.title, href: tag.feed}
    ];
  }

  get resourceUrl() {
    return `/api/tags/${this.props.params.slug}.json`;
  }

  callback(error, response) {
    this.setState(response.body);
  }
}
