'use strict';

import Link from './Link';
import React from 'react/addons';
import moment from 'moment';

// CSS
import './PostInfo.css';

export default class PostInfo extends React.Component {
  constructor(props) {
    if (!props.data.tags) { props.data.tags = []; }
    super(props);
  }

  get publishedOn() {
    return moment(this.props.data.published_on).fromNow();
  }

  render() {
    var tagNodes = this.props.data.tags.map((tag) =>
      <span>
        <Link to="tag" params={{slug: tag.slug}}>
          {tag.title}
        </Link>
      </span>
    );

    return (
      <div className="post-info">
      <strong>Tags: </strong>
        <span className="tags">
          {tagNodes}
        </span>

        <em>Written {this.publishedOn}.</em>

        <p className="excerpt">
          {this.props.data.excerpt}
        </p>
      </div>
    );
  }
}
