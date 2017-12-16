# APACTravelsWebPage

Sample Travels Webpage for APAC written using Sinatra.  Email confirmations sent out using SendGrid.
  
[Sinatra](http://sinatrarb.com/intro.html)  
[SendGrid](https://sendgrid.com/)  
[Payments done with Stripe Checkout](https://stripe.com/checkout)  

I used SendGrid to create my own email templates to send to users when they submit their payment.  It was really nice working with the SendGrid API compared to the MailGun API (MailGun required me to configure a domain.  I wanted something simpler to get started since I was deploying my app to Heroku).  Once I created each email template, I constructed my Json and plugged it into the SendGrid API and viola it worked!

Here is an example of how to send an email with the SendGrid API using a SendGrid Template.

This [guide](https://app.sendgrid.com/guide/integrate/langs/ruby) is helpful when working with SendGrid 

```ruby
json_map = { 'personalizations' => [
    { 
      'to' =>  [{ 'email' => "#{toEmail}" }], 
      'subject' => 'Thank you for booking with APAC Travels'  
    }], 
    'from' => { 'email' => "#{fromEmail}" },
    'template_id' => "#{templateID}",
    'content' => [{ 'type' => 'text/html', 'value' => 'its easy to do' }]
  }

  json_map.to_json
  data = json_map

  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  response = sg.client.mail._("send").post(request_body: data)
  puts response.status_code
  puts response.body
  puts response.headers
```

Working with Stripe Checkout was also really simple.  Just plug in the Javascript they provide on their website in your HTML, setup your Sinatra code to handle the response and your done.  Stripe has a [tutorial](http://sinatrarb.com/intro.html) on how to get a Sinatra app working with Stripe.

Here is how I run the app in terminal:  
SingTemplate=<SENDGRID_SINGAPORE_TEMPLATE_HERE> ThaiTemplate=<SENDGRID_THAILAND_TEMPLATE_HERE> ChinaTemplate=<SENDGRID_CHINA_TEMPLATE_HERE> VietnamTemplate=<SENDGRID_VIETNAM_TEMPLATE_HERE> CambodiaTemplate=<SENDGRID_CAMBODIA_TEMPLATE_HERE> SENDGRID_API_KEY=<YOUR_SEND_GRID_API_KEY> SUPPORT_EMAIL=<SENDER_EMAIL> PUBLISHABLE_KEY=<PUBLISHABLE_KEY> SECRET_KEY=<SECRET_KEY> ruby myapp.rb