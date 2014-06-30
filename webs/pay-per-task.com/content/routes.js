window.routes = [
  {
    "path": "/",
    "templateUrl": "/templates/index.html",
    "title": "PPT: The secret weapon in MOTIVATING your IT team!"
  },

  {
    "path": "/contractors",
    "templateUrl": "/templates/contractors.html",
    "title": "PPT: GET PAID for your work in REALTIME!"
  },

  {
    "path": "/pricing",
    "templateUrl": "/templates/pricing.html",
    "title": "PPT: Pricing"
  },

  {
    "path": "/about-us",
    "templateUrl": "/templates/about-us.html",
    "title": "PPT: About Us"
  },

  {
    "path": "/contact",
    "templateUrl": "/templates/contact.html",
    "title": "PPT: Contact"
  },

  {
    "path": "/newsletter",
    "templateUrl": "/templates/newsletter.html",
    "title": "PPT: Sign up now!",
    "controller": "NewsletterController"
  },

  {
    "path": "/sign-up/:plan",
    "templateUrl": "/templates/sign-up.html",
    "title": "PPT Onboarding",
    "controller": "OnboardingController"
  }
]
