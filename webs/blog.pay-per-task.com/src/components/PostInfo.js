'use strict';

import {Link} from 'react-router';
import React from 'react/addons';

// CSS
import './PostInfo.css';

export default class PostInfo extends React.Component {
  constructor(props) {
    if (!props.data.tags) { props.data.tags = []; }
    super(props);
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
        <em>{this.props.data.published_on}</em>

        <div className="tags">
          {tagNodes}
        </div>

        <p className="excerpt">
          {this.props.data.excerpt}
        </p>
      </div>
    );
  }
}
