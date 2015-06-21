import React from 'react/addons';
import Head from 'react-helmet';

// How to write it in the ES6 syntax?
exports.React = React;

export class Component extends React.Component {
  get metadata() {
    return this.props.metadata || {};
  }

  get title() {
    return this.metadata.title;
  }

  get meta() {
    return [
      {name: 'description', content: this.title},
      {property: 'og:type', content: 'article'}
    ];
  }

  get links() {
    return [
      {rel: 'canonical', href: this.metadata.base_url},
      {rel: 'alternate', title: this.metadata.title, href: this.metadata.feed}
      // {rel: 'apple-touch-icon', href: 'http://mysite.com/img/apple-touch-icon-57x57.png'},
      // {rel: 'apple-touch-icon', sizes: '72x72', href: 'http://mysite.com/img/apple-touch-icon-72x72.png'}
    ];
  }

  render() {
    return <Head
      title={this.title}
      meta={this.meta}
      link={this.links}
    />;
  }
}
