// This doesn't know JSX and ES6.
var tags = require('../dist/api/tags.json'),
  posts  = require('../dist/api/posts.json');

var fs = require('fs');
var React = require('react');

console.log(posts)
posts.forEach(function (post) {
  var path = 'x/' + post.slug + '.json';
  // This won't work either, we have to use BlogApp and BlogApp uses the router.
  var html = React.renderToString(<Post slug={post.slug} />);
  fs.write(path, html)
});

// tags.forEach(function (tag) {
//   var path = 'x/' + tag.slug + '.json';
//   var html = React.renderToString(<Tag slug={tag.slug} />);
//   fs.write(path, html)
// });
