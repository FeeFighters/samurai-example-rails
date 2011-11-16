class ServerToServerController < ApplicationController

  # Payment form for Server-to-Server API
  # -------------------------------------
  #
  # * Displays a payment form that POSTs to the purchase method below
  # * The credit card data is provided directly to this rails server, where it is used to process a
  #   transaction entirely on the backend.
  # * A payment_method_token or reference_id can be provided in the params so that validation errors can be displayed.
  #
  def payment_form
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
      redirect_to transparent_redirect_payment_form_path(payment_method_params) and return
    end

    @transaction = Samurai::Processor.the_processor.purchase(
      @payment_method.token,
      22.22,  # The price for the Transparent Redirect Nunchucks
      {
        :descriptor => 'Transparent Redirect Nunchucks',
        :customer_reference => Time.now.to_f,
        :billing_reference => Time.now.to_f
      }
    )

    if @transaction.failed?
      redirect_to transparent_redirect_payment_form_path(payment_method_params) and return
    end

    redirect_to transparent_redirect_show_path
  end

  # Purchase confirmation & receipt page
  # ------------------------------------
  def receipt
  end

end