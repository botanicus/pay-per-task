#/bin/sh

sudo tee -a /etc/hosts <<EOF
127.0.0.1 in.pay-per-task.dev
127.0.0.1 api.pay-per-task.dev

127.0.0.1 in.pay-per-task.test
127.0.0.1 api.pay-per-task.test

127.0.0.1 pay-per-task.dev
127.0.0.1 app.pay-per-task.dev
127.0.0.1 blog.pay-per-task.dev
127.0.0.1 cdn.pay-per-task.dev

127.0.0.1 docs.pay-per-task.dev
EOF
