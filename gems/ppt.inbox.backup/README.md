## About

**Development status:** stable and tested.

This consumer appends any JSON into a YAML file. YAML is used due to its support for multiple documents and because [JSON is a subset of YAML](http://en.wikipedia.org/wiki/YAML#JSON).

- **Queue:** `inbox.backup`
- **Queue binds to:** `inbox.#` of `amq.topic`.
- **Format:** (any) JSON is expected.
- **Output:** Appends to `data/inbox/[service]/[username].yml`.
- **Error handling:** Malformatted JSON results in a log message.

## Making Sure It Works

Run `bundle exec rspec`. It is an integration tests, it will fail if the consumer is not running.

## Alternative Design

Instead of having every service consuming `inbox.#`, this could be the entry point which would validate the JSON and then publish the minified version of it with a new type of routing key, say `input.#`.

By not doing `ppt.inbox.backup` and `ppt.inbox.[service]` can run simultaneously.

The difference is fairly subtle, it can be either way I reckon.
