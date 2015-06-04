# About

**Development status:** WIP and untested.

This consumer parses whatever we get from Pivotal Tracker through their webhooks API and stores it to Redis or update it if it has been created already.

It relies on the PT API v5 and it uses the company object and the API key from there.

- **Queue:** `inbox.pt`
- **Queue binds to:** `inbox.pt.#` of `amq.topic`.
- **Format:** (any) JSON is expected.
- **Output:**
  - Stories and devs are stored to Redis.
  - Their JSON is then published to `devs.new` resp. `stories.new`.
- **Error handling:** Malformatted JSON results in a log message.

# Release

- Make sure you pushed current version of ppt and other libraries.
https://manage.fury.io/dashboard/botanicus#/intro?kind=ruby
curl -F package=@ppt-0.0.1.gem https://2o3qM2tByL-as-g1Esde@push.fury.io/botanicus/

rake build
