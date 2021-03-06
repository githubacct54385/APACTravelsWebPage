require 'sinatra'
require 'stripe'
require 'sendgrid-ruby'
require 'mail'
require 'json'
include SendGrid

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

# You can find your endpoint's secret in your webhook settings
set :signing_secret, ENV['SIGNINGSECRET']

Stripe.api_key = settings.secret_key

get '/' do
  erb :index
end

post '/InvoicePaymentSucceeded' do

  payload = request.body.read
  sig_header = request.env['HTTP_STRIPE_SIGNATURE']
  event = nil

  begin
    event = Stripe::Webhook.construct_event(
      payload, sig_header, settings.signing_secret
    )
  rescue JSON::ParserError => e
    # Invalid payload
    status 400
    return
  rescue Stripe::SignatureVerificationError => e
    # Invalid signature
    status 400
    return
  end

  status 200

  event_id = JSON.parse(payload)["id"].to_s
  
  # get the event from the Stripe API (Helps to verify it is not fraudulent)
  stripe_event = Stripe::Event.retrieve(event_id)

  puts stripe_event.to_s
  puts 'Event ID: ' + stripe_event["id"].to_s  

  customer = Stripe::Customer.retrieve(stripe_event["data"]["object"]["customer"])
  puts 'Customer: ' + customer.email

  content = "Thank you for your continued business using APAC Travels!"

  SendTestEmail(customer.email.to_s, 'Invoice Succeeded for APAC Travels', content)
end

def SendTestEmail(destEmail, subject, content)
  fromEmail = ENV['SUPPORT_EMAIL']
  json_map = { 'personalizations' => [
    { 
      'to' =>  [{ 'email' => "#{destEmail}" }], 
      'subject' => "#{subject}"  
    }], 
    'from' => { 'email' => "#{fromEmail}" },
    'content' => [{ 'type' => 'text/html', 'value' => "#{content}" }]
  }

  json_map.to_json
  data = json_map

  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  response = sg.client.mail._("send").post(request_body: data)
  puts response.status_code
  puts response.body
  puts response.headers
end

def SendEmailUsingTemplateJson(toEmail, dest)
  templateID = "None"
  case dest
  when "Singapore"
    templateID = ENV['SingTemplate']
  when "Thailand"
    templateID = ENV['ThaiTemplate']
  when "China"
    templateID = ENV['ChinaTemplate']
  when "Vietnam"
    templateID = ENV['VietnamTemplate']
  when "Cambodia"
    templateID = ENV['CambodiaTemplate']
  else
    puts "Unknown dest variable" + dest.to_s
    return
  end
  fromEmail = ENV['SUPPORT_EMAIL']

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
end

def SendChargeSucceedEmail(email)
  from = Email.new(email: ENV['SUPPORT_EMAIL'])
  to = Email.new(email: email.to_s)

  contentDest = 'Charge Succeeded!!!' 
  subject = 'Your charge was successful!'
  content = Content.new(type: 'text/plain', value: contentDest)
  mail = Mail.new(from, subject, to, content)

  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  response = sg.client.mail._('send').post(request_body: mail.to_json)
  puts response.status_code
  puts response.body
  puts response.headers

end

# Sends non-templated email, not used anymore
def SendEmail(email, dest)
  from = Email.new(email: ENV['SUPPORT_EMAIL'])
  to = Email.new(email: email.to_s)
  contentDest = 'We hope you enjoy your stay in ' + dest.to_s + '!' 
  subject = 'Your charge was successful!'
  content = Content.new(type: 'text/plain', value: contentDest)
  mail = Mail.new(from, subject, to, content)

  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  response = sg.client.mail._('send').post(request_body: mail.to_json)
  puts response.status_code
  puts response.body
  puts response.headers
end

post '/chargeSingapore' do
	# Amount in cents
  @amount = 80000
  @sendEmail = params[:stripeEmail]

  customer = CreateOrRetrieveCustomer(@sendEmail)

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge - Singapore Flight + Hotel',
    :currency    => 'usd',
    :customer    => customer.id
  )

  @dest = "Singapore"
  SendEmailUsingTemplateJson(@sendEmail, @dest)
  erb :charge
end

post '/chargeThailand' do
	# Amount in cents
  @amount = 80000
  @sendEmail = params[:stripeEmail]

  customer = CreateOrRetrieveCustomer(@sendEmail)

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge - Thailand Flight + Hotel',
    :currency    => 'usd',
    :customer    => customer.id
  )

  @dest = "Thailand"
  SendEmailUsingTemplateJson(@sendEmail, @dest)
  erb :charge
end

post '/chargeChina' do
	# Amount in cents
  @amount = 80000
  @sendEmail = params[:stripeEmail]

	customer = CreateOrRetrieveCustomer(@sendEmail)

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge - China Flight + Hotel',
    :currency    => 'usd',
    :customer    => customer.id
  )

	@dest = "China"
  SendEmailUsingTemplateJson(@sendEmail, @dest)
  erb :charge
end

post '/chargeVietnam' do
	# Amount in cents
  @amount = 80000
  @sendEmail = params[:stripeEmail]

	customer = CreateOrRetrieveCustomer(@sendEmail)

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge - Vietnam Flight + Hotel',
    :currency    => 'usd',
    :customer    => customer.id
  )

	@dest = "Vietnam"
  SendEmailUsingTemplateJson(@sendEmail, @dest)
  erb :charge
end

post '/chargeCambodia' do
	# Amount in cents
  @amount = 80000
  @sendEmail = params[:stripeEmail]

	customer = CreateOrRetrieveCustomer(@sendEmail)

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge - Cambodia Flight + Hotel',
    :currency    => 'usd',
    :customer    => customer.id
  )

	@dest = "Cambodia"
  SendEmailUsingTemplateJson(@sendEmail, @dest)
  erb :charge
end

#post '/subscribeTravelRewards' do
#  @amount = 1000
#  @custEmail = params[:stripeEmail]

#  customer = Stripe::Customer.create(
#    :email => @custEmail,
#    :source  => params[:stripeToken]
#  )

#  puts customer

  #Stripe::Subscription.create(
  #  :customer => customer.id,
  #  :items => [
  #    {
  #      :plan => "123",
  #    },
  #  ],
  #)

#  erb :subscribedTravelRewards
#end

def CreateOrRetrieveCustomer(customerEmail)
  # Get first customer with matching email to cardholder-email
  customers = Stripe::Customer.list(limit: 1, email: customerEmail)

  # Initialize empty customer variable to be set below
  customer = nil

  # If not matching customer, create a new one
  if customers.data.empty?
    customer = Stripe::Customer.create(
      :email => params[:"cardholder-email"],
      :source  => params[:stripeToken],
      :description => "Customer for #{params[:"cardholder-email"]}"
    )
  # If matching customer found, get from stripe  
  else
    customer = Stripe::Customer.retrieve(customers.data.first.id)
  end
  return customer
end

error Stripe::CardError do
  env['sinatra.error'].message
end