require 'sinatra'
require 'stripe'
require 'sendgrid-ruby'
require 'mail'
require 'json'
include SendGrid

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

get '/' do
  erb :index
end

post '/webhook2' do

  #@sendEmail = 'alexbarke002@gmail.com'
  @dest = 'Singapore'

  # Retrieve the request's body and parse it as JSON
  @event_json = JSON.parse(request.body.read)

  # Retrieve the event from Stripe
  @event = Stripe::Event.retrieve(@event_json['id'])

  if @event.type.eql?('charge.succeeded')
    @email = @event.data.name
    SendEmailUsingTemplateJson(@email, @dest)

  end
  status 200

end

post '/webhook' do

  puts "Enter webhook code"
  # Retrieve the request's body and parse it as JSON
  @event_json = JSON.parse(request.body.read)

  # Retrieve the event from Stripe
  @event = Stripe::Event.retrieve(@event_json['id'])

  SendEmailUsingTemplateJson('alexbarke002@gmail.com', 'Singapore')
  status 200
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

  customer = Stripe::Customer.create(
    :email => @sendEmail,
    :source  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge - Singapore Flight + Hotel',
    :currency    => 'usd',
    :customer    => customer.id
  )

  @dest = "Singapore"
  #SendEmailUsingTemplateJson(@sendEmail, @dest)
  SendEmail(@sendEmail, @dest)
  erb :charge
end

post '/chargeThailand' do
	# Amount in cents
  @amount = 80000
  @sendEmail = params[:stripeEmail]

	customer = Stripe::Customer.create(
    :email => 'customer@example.com',
    :source  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge - Thailand Flight + Hotel',
    :currency    => 'usd',
    :customer    => customer.id
  )

  @dest = "Thailand"
  #SendEmail(@sendEmail, @dest)
  SendEmailUsingTemplateJson(@sendEmail, @dest)
  erb :charge
end

post '/chargeChina' do
	# Amount in cents
  @amount = 80000
  @sendEmail = params[:stripeEmail]

	customer = Stripe::Customer.create(
    :email => 'customer@example.com',
    :source  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge - China Flight + Hotel',
    :currency    => 'usd',
    :customer    => customer.id
  )

	@dest = "China"
  #SendEmail(@sendEmail, @dest)
  SendEmailUsingTemplateJson(@sendEmail, @dest)
  erb :charge
end

post '/chargeVietnam' do
	# Amount in cents
  @amount = 80000
  @sendEmail = params[:stripeEmail]

	customer = Stripe::Customer.create(
    :email => 'customer@example.com',
    :source  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge - Vietnam Flight + Hotel',
    :currency    => 'usd',
    :customer    => customer.id
  )

	@dest = "Vietnam"
  #SendEmail(@sendEmail, @dest)
  SendEmailUsingTemplateJson(@sendEmail, @dest)
  erb :charge
end

post '/chargeCambodia' do
	# Amount in cents
  @amount = 80000
  @sendEmail = params[:stripeEmail]

	customer = Stripe::Customer.create(
    :email => 'customer@example.com',
    :source  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge - Cambodia Flight + Hotel',
    :currency    => 'usd',
    :customer    => customer.id
  )

	@dest = "Cambodia"
  #SendEmail(@sendEmail, @dest)
  SendEmailUsingTemplateJson(@sendEmail, @dest)
  erb :charge
end

error Stripe::CardError do
  env['sinatra.error'].message
end