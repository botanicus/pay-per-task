'use strict';

import {Link} from 'react-router';
import React from 'react/addons';

require('./PostInfo.css')

class PostInfo extends React.Component {
  constructor(props) {
    super(props);
    this.props.data.tags = [];
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

module.exports = PostInfo;
