# Scalling

*PPT runs on one VPS which most likely will be plenty. I'm therefore not overly concerned about scalling, I'm all trying to do is to make it possible to scale if needed.*

That consists of:

- Using software which can be (reasonably easily) clustered.
- Developing the app in such manner that it can go to cloud easily.

# Current Limitations

Consumer **ppt.inbox.backup** saves everything to the file system. It doesn't matter too much since this is only just-in-case and also I still might decide to use the API to crawl the apps regularly, since now **ppt.webs.in** is the single point of failure.

# Used Software & Its Scalling Options
