#!/usr/bin/env babel-node

GLOBAL._require = require;
GLOBAL.require = function require (path) {
  // console.log(path)
  // console.log(path.match(/\.css$/))
  // if (path.match(/\.css$/)) return;
  console.log("~ Loading " + path);
  return _require(path);
}
import tags from '../dist/api/tags.json';
import posts from '../dist/api/posts.json';
// import Post from './components/Post'

import fs from 'fs';
import React from 'react';

console.log(posts)
posts.forEach(function (post) {
  var path = 'x/' + post.slug + '.json';
  // This won't work either, we have to use BlogApp and BlogApp uses the router.
  // var html = React.renderToString(<Post slug={post.slug} />);
  // fs.write(path, html)
});

// tags.forEach(function (tag) {
//   var path = 'x/' + tag.slug + '.json';
//   var html = React.renderToString(<Tag slug={tag.slug} />);
//   fs.write(path, html)
// });
