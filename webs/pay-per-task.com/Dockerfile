FROM lampe/minimal-nginx:latest-busybox

# Override the existing default vhost.
COPY vhost.conf /etc/nginx/sites-enabled/default

ENV ROOT /webs/pay-per-task.com

EXPOSE 80

RUN mkdir -p $ROOT
ADD . $ROOT
