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

def SendEmailUsingTemplateJson(emailParam, dest)
  templateID = "None"
  case dest
  when "Singapore"
    templateID = "a6e4dcc3-276b-4d32-8169-3024136e1ce8"
  when "Thailand"
    templateID = "0293268b-8887-4cb4-a04a-151afd831bb6"
  when "China"
    templateID = "9b18595c-d90e-4354-bda3-3662e965642c"
  when "Vietnam"
    templateID = "239cf341-d9b1-4d6a-aa42-a5a01fac4b6b"
  when "Cambodia"
    templateID = "bf930d96-2969-437c-bf5a-0b0f12e76468"
  else
    puts "Unknown dest variable" + dest.to_s
    return
  end
  supportEmail = ENV['SUPPORT_EMAIL']

  json_map = { 'personalizations' => [
  { 
    'to' =>  [{ 'email' => "#{emailParam}" }], 
    'subject' => 'Thank you for booking with APAC Travels'  
  }], 
  'from' => { 'email' => "#{supportEmail}" },
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


# Sends non-templated email, not used anymore
def SendEmail(email, dest)
  from = Email.new(email: ENV['SUPPORT_EMAIL'])
  to = Email.new(email: email.to_s)
  contentDest = 'We hope you enjoy your stay in ' + dest.to_s + '!' 
  subject = 'Thank you for signing up with APAC Travels!'
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
    :email => 'customer@example.com',
    :source  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge - Singapore Flight + Hotel',
    :currency    => 'usd',
    :customer    => customer.id
  )

  @dest = "Singapore"
  SendEmailUsingTemplateJson(@sendEmail, @dest)
  #SendEmail(@sendEmail, @dest)
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