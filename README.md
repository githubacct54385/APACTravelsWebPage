# APACTravelsWebPage

Sample Travels Webpage for APAC written using Rails w/ Sinatra.  Email confirmations sent out using SendGrid.

Install Rails - http://installrails.com/  
Sinatra - http://sinatrarb.com/intro.html  
SendGrid - https://sendgrid.com/  
Payments done with Stripe Checkout - https://stripe.com/checkout  

I used SendGrid to create my own email templates to send to users when they submit their payment.  It was really nice working with the SendGrid API compared to the MailGun API (MailGun required me to configure a domain.  I wanted something simpler to get started since I was deploying my app to Heroku).  Once I created each email template, I constructed my Json and plugged it into the SendGrid API and viola it worked!

Working with Stripe Checkout was also really simple.  Just plug in the Javascript they provide on their website in your HTML, setup your Rails code to handle the response and your done.  Stripe has a tutorial on how to get a Rails app working with Stripe here (http://sinatrarb.com/intro.html).        


SingTemplate=<SENDGRID_SINGAPORE_TEMPLATE_HERE> ThaiTemplate=<SENDGRID_THAILAND_TEMPLATE_HERE> ChinaTemplate=<SENDGRID_CHINA_TEMPLATE_HERE> VietnamTemplate=<SENDGRID_VIETNAM_TEMPLATE_HERE> CambodiaTemplate=<SENDGRID_CAMBODIA_TEMPLATE_HERE> SENDGRID_API_KEY=<YOUR_SEND_GRID_API_KEY> SUPPORT_EMAIL=<SENDER_EMAIL> PUBLISHABLE_KEY=<PUBLISHABLE_KEY> SECRET_KEY=<SECRET_KEY> ruby myapp.rb