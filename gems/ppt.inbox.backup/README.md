## About

**Development status:** stable and reasonably tested, only [the upstart script isn't working](https://gist.github.com/botanicus/da85c8c93732f549b6f1#file-readme-md).

This consumer appends any JSON into a YAML file. YAML is used due to its support for multiple documents and because [JSON is a subset of YAML](http://en.wikipedia.org/wiki/YAML#JSON).

- **Queue:** `inbox.backup`
- **Queue binds to:** `inbox.#` of `amq.topic`.
- **Format:** (any) JSON is expected.
- **Output:** Appends to `data/inbox/[service]/[username].yml`.
- **Error handling:** Malformatted JSON results in a log message.

## Alternative Design

Instead of having every service consuming `inbox.#`, this could be the entry point which would validate the JSON and then publish the minified version of it with a new type of routing key, say `input.#`.

By not doing `ppt.inbox.backup` and `ppt.inbox.[service]` can run simultaneously.

The difference is fairly subtle, it can be either way I reckon.
