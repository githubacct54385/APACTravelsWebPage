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

error Stripe::CardError do
  env['sinatra.error'].message
end