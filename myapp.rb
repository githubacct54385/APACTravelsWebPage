require 'sinatra'
require 'stripe'
require 'sendgrid-ruby'
include SendGrid

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

get '/' do
  erb :index
end

def SendEmail(email, dest)
  from = Email.new(email: ENV['SUPPORT_EMAIL'])
  to = Email.new(email: email)
  #contentDest = 'We hope you enjoy your stay in ' + dest.to_s + '!' 
  contentDest = 'We hope you enjoy your vacation!'
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
  erb :charge
end

error Stripe::CardError do
  env['sinatra.error'].message
end