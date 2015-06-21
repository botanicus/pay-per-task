'use strict';

import PostList from './PostList';

export default class Tag extends PostList {
  get resourceUrl() {
    return `/api/tags/${this.props.params.slug}.json`;
  }

  callback(error, response) {
    this.setState(response.body);
  }
}
