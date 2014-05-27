# Cross-Domain Authentication

## From the App

## From the Landing Page

# http://stackoverflow.com/questions/18492576/share-cookie-between-subdomain-and-domain
# Set-Cookie: session_id=123; domain=pay-per-task.com


One local session manager
login.pay-per-task.com

success(function (data) cookies.set(session_id = data.session_id) ) ... NOT enough, then when I just log in on the app, it won't "update" as a global cookie would
