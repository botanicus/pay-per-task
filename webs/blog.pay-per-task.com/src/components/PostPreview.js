'use strict';

import React from 'react/addons';

class PostPreview extends React.Component {
  render() {
    var tagNodes = this.props.data.tags.map((tag) =>
      <span>
        <a href={tag.path}>
          {tag.title}
        </a>
      </span>
    );

    return (
      <div className="post-preview">
        <h2>
          <a href={this.props.data.path}>
            {this.props.data.title}
          </a>
        </h2>

        {this.props.data.published_on}

        <span className="tags">
          {tagNodes}
        </span>

        <p className="excerpt">
          {this.props.data.excerpt}
        </p>
      </div>
    );
  }
}

module.exports = PostPreview;
