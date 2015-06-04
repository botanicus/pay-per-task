# Repository structure discussion

_This discussion is about the Git repository, not about (albeit related) structure of Docker containers. There the solution is simple: Docker is meant to run one process per container. That means that there has to be at least all the static webs, in.ppt.com and api.ppt.com. Since we're at it though, I don't see any reason why all of those shouldn't have their own container._

## Everything in one repository

### Benefits

- COMMITS ARE ATOMIC: one repository ensures that I can commit both frontend and app in the same time. Otherwise I'd have to tag it constantly (dependency on given SHA).
- It's pretty much for free, currently we pay only for GitHub $7 per month.
- We don't need to use a reverse proxy, all is in one Nginx instance. But then again, reverse proxy is good - ready for scaling for once.
- When a new sub-project is added, everyone gets it immediately.
- We can have stuff like this folder with docs, stuff that wouldn't otherwise be worth putting into a repository and would probably go to a wiki, but fuck, Git is better!
- We can use

### Problems

- Docker = 1 process per image (ideally ... ).

## More granular structure

### Benefits

- One repo = one project is expected by services like Codeship. Running CI, Dockerhub builds etc would be easy.
- Scaling is a piece of cake.

### Technical issues

- Managing dependencies on CI (the frontend needs the API that corresponds to that version of frontend code).

#### Managing docker dependencies

- Every time I want to run the frontend or the landing page, I want to run it with the API since it depends on it.
- When I'm developing the frontend and the API at once, how do I run it?

### Price

- BitBucket: free for up to 5 users. (Organisations are called groups there.)
- GitHub: 10 private repos for $10 per month, 20 per $22. In case of an organisation it is 10 for $25, 20 for $50.
- On top of that we'd have to pay for Slack (5 integrations are free, then it's $8 per user per month).
- Codeship: 5 repos are for free, more for $50. Alternative: privately hosted Jenkins CI.
- Dockerhub: free 1 repository, $7 pm for 5, $12 for 10, $22 for 20. Alternative: Tutum has this for free, although I found it a bit tricky, esp. with the deployment pipeline.
- Potentially other services.
- Price altogether for 3 people:
  - BitBucket 0 + Slack (8 * 3) + Codeship 50 = $74 per month, $888 per year.
  - BitBucket 0 + Slack (8 * 3) + private Jenkins CI = $24 per month, $288 per year.

## Should each web have a separate repository?

Currently these are the dependencies:

- `pay-per-task.com` -> `api.pay-per-task.com`
- `app.pay-per-task.com` -> `api.pay-per-task.com`

- `in.pay-per-task.com`
- `blog.pay-per-task.com`
- `api.pay-per-task.com`

in - ruby image, 1 process
api - ruby image, 1 process
blog app landing-page - Nginx image, 1 process
