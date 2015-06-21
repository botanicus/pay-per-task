'use strict';

import {Link} from 'react-router';
import React from 'react/addons';
import PostInfo from './PostInfo';

export default class PostPreview extends React.Component {
  render() {
    return (
      <div className="post-preview">
        <h2>
          <Link to="post" params={{slug: this.props.data.slug}}>
            {this.props.data.title}
          </Link>
        </h2>

        <PostInfo data={this.props.data} />
      </div>
    );
  }
}
