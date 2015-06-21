'use strict';

import {Link} from 'react-router';
import React from 'react/addons';

// <Link to="post" params={{slug: post.slug}} />
export default class LinkToUnlessCurrent extends React.Component {
  render() {
    this.element = (
      <Link to={this.props.to} params={this.props.params}>
        {this.props.children}
      </Link>
    )
    var html = React.renderToString(this.element);
    var link = html.match(/.*href="([^"]+).*"/)[1];

    if (window.location.pathname === link) {
      return <span>{this.props.children}</span>;
    } else {
      return this.element;
    }
  }
}
