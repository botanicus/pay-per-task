## About

**Development status:** stable and reasonably tested, only [the upstart script isn't working](https://gist.github.com/botanicus/da85c8c93732f549b6f1#file-readme-md).

This consumer appends any JSON into a YAML file. YAML is used due to its support for multiple documents and because JSON is effectively subset of YAML, however surprising it is.

- **Queue:** `ppt.inbox.backup`
- **Queue bound to:** **inbox.#** of `amq.topic`.
- **Format:** (any) JSON is expected.
- **Output:** Appends to `data/inbox/[service]/[username].yml`.
