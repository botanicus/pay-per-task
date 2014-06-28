## About

**Development status:** WIP and untested and [the upstart script isn't working](https://gist.github.com/botanicus/da85c8c93732f549b6f1#file-readme-md).

This consumer parses whatever we get from Pivotal Tracker through their webhooks API and stores it to Redis or update it if it has been created already.

- **Queue:** `inbox.pt`
- **Queue binds to:** `inbox.pt.#` of `amq.topic`.
- **Format:** (any) JSON is expected.
- **Output:**
  - Stories and devs are stored to Redis.
  - Their JSON is then published to `devs.new` resp. `stories.new`.
- **Error handling:** Malformatted JSON results in a log message.
