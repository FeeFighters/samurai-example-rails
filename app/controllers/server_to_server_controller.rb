class ServerToServerController < ApplicationController
  include Samurai::Rails::Helpers

  # Payment form for Server-to-Server API
  # -------------------------------------
  #
  # * Displays a payment form that POSTs to the purchase method below
  # * The credit card data is provided directly to this rails server, where it is used to process a
  #   transaction entirely on the backend.
  # * A payment_method_token or reference_id can be provided in the params so that validation errors can be displayed.
  #
  def payment_form 
    unless params[:payment_method_token].blank?
      @payment_method = Samurai::PaymentMethod.find params[:payment_method_token]
    else
      @payment_method = Samurai::PaymentMethod.new :is_sensitive_data_valid => false
    end

    unless params[:reference_id].blank?
      @transaction = Samurai::Transaction.find params[:reference_id]
    end
  end

  # Purchase action for Server-to-Server API
  # ----------------------------------------
  #
  # * Payment Method details are POST'ed directly to the server, which performs a S2S API call
  # * NOTE: This approach is typically not recommended, as it comes with a much greater PCI compliance burden
  #   In general, it is a good idea to prevent the credit card details from ever touching your server.
  #
  def purchase
    @payment_method = Samurai::PaymentMethod.create params[:payment_method]
    if @payment_method.nil?
      redirect_to server_to_server_payment_form_path and return
    end

    @transaction = Samurai::Processor.the_processor.purchase(
      @payment_method.token,
      122.00,  # The price for the Server-to-Server Battle Axe + Shipping
      {
        :descriptor => 'Server-to-Server Battle Axe',
        :customer_reference => Time.now.to_f,
        :billing_reference => Time.now.to_f
      }
    )

    unless @transaction.success
      redirect_to server_to_server_payment_form_path(:payment_method_token => @payment_method.token, :reference_id => @transaction.reference_id) and return
    end

    redirect_to server_to_server_receipt_path
  end

  # Purchase confirmation & receipt page
  # ------------------------------------
  def receipt
  end

end
