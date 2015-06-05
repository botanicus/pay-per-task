# Deployment pipeline

# This is a problem.
# We're waiting for this to finish, even though we just care about the specs at this point.
# What's worse though is that fail here means CI fail. We can handle it manually, but ...
# Also

GitHub -> Dockerhub / Tutum -> CI -> Tutum.
GitHub -> CI (build image & run tests) -> (per repo) push to Dockerhub / Tutum (not an automated build) -> Tutum.

where should the image be build? Aka we don't have to add bower_components if the build would be done on a CI where it'd also run bower install.

Run tests tagged @production against the production site after deployment.
curl -i https://codeship.com/api/v1/projects/83840.json?api_key=31624550ecd801322af5768767ec3f20
