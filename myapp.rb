require 'sinatra'
require 'stripe'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

get '/' do
  erb :index
end

post '/chargeSingapore' do
	# Amount in cents
  	@amount = 80000

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
  	erb :charge
end

post '/chargeThailand' do
	# Amount in cents
  	@amount = 80000

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
  	erb :charge
end

post '/chargeChina' do
	# Amount in cents
  	@amount = 80000

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
  	erb :charge
end

post '/chargeVietnam' do
	# Amount in cents
  	@amount = 80000

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
  	erb :charge
end

post '/chargeCambodia' do
	# Amount in cents
  	@amount = 80000

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
  	erb :charge
end

error Stripe::CardError do
  env['sinatra.error'].message
end