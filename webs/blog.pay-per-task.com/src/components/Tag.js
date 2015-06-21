'use strict';

import PostsList from './PostsList';

export default class Tag extends PostsList {
  get resourceUrl() {
    return `/api/tags/${this.props.params.slug}.json`;
  }
}
