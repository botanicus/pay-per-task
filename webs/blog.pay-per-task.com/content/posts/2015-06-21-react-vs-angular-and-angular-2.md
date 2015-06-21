title: "React vs. Angular vs. Angular 2"
tags: ['AngularJS', 'ReactJS', 'JavaScript']
author: James C Russell
email: james@pay-per-task.com
---

<div id="excerpt">
  Documentation is something many companies don't care too much about.
</div>

Mate, when I was on a plane I had some read on Angular 2 and React.js. Very interesting. When I started this, Angular 2 wasn’t about (now it’s like alpha, docs quite sucks, but I guess it can be used) and React.js was the new thing which not many people were using at that point.

Now while I still like Angular 1 very much, I think we should build the new shit (blog, frontend …) in something else.

Angular 2 has nothing to do with Angular 1, it’s a brutal rewrite. Both Angular 2 and React.js went down the component route. It’s a great pattern and I really like it. In Angular 1 I had a problem when you went just a bit down the rabbit hole and needed to write your components, it was not trivial and you had to write HTML in your JS files, compile it, make sure the data got updated (there were issues) and so on and so forth.

Components is the way it all seems to be going, i. e. Web Components.
Personally I love this approach and it’s what’s been used in our backend, taking into more extreme measures, in terms of making those services and not just components, but it’s the same methodology nonetheless.

MVC doesn’t scale, we’ve seen that in NOTHS: it’s bloody fucking impossible to break it down into services. AIn’t gonna happen. /// Think more about it. Is it actually possible in this?

With React.js you actually do put your HTML into your js files, but in a very different way. …. /// check out how was it.
JSX

One important thing about React.js is it doesn’t depend on DOM. You can render HTML on the server from Node.js + React.js, send it to the client and then let *frontend* React.js to pick up, bind events to it and continue as a normal single page app.

// Random thought: generate static HTML, so it’s just Nginx.

Apart of the obvious speed benefits, it makes it indexable by bots (Google bot is supposed to evaluate JS as of now as far as I know, but I don’t think it works too welll(?)) and makes testing ridiculously easy and fast: you no longer need Capybara/Protractor to do any sort of testing. I’m not saying you shouldn’t, you absolutely should, but it’s no longer necessary.

ES6

Angular 2 on the other hand … TypeScript. Cherry-picking

Overall Angular 1 is a great tool for simple projects like our landing page, but React.js and Angular 2 are more suitable for larger projects.
