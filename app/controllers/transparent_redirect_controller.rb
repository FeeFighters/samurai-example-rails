class TransparentRedirectController < ApplicationController
  include Samurai::Rails::Helpers

  # Payment form for Transparent Redirect
  # ------------------------------
  #
  # * Displays a payment form using the Samurai Rails helpers bundled in the gem
  # * Payment form is initialized with PaymentMethod data, if a token is passed in the params.
  #   This allows validation & processor-response error messages to be displayed.
  def payment_form
    setup_for_transparent_redirect(params)
  end

  # Purchase action for Transparent Redirect
  # ------------------------------
  #
  # * This action is requested as the callback from the Samurai.js Transparent Redirect
  # * It performs the purchase, and redirects the user to the purchase confirmation page
  # * On error, it redirects back to the payment form to display validation/card errors
  #
  def purchase
    load_and_verify_payment_method(params)
    redirect_to transparent_redirect_payment_form_path(payment_method_params) and return unless @payment_method

    @transaction = Samurai::Processor.the_processor.purchase(
      @payment_method.token,
      122.00,  # The price for the Transparent Redirect Nunchucks
      {
        :descriptor => 'Transparent Redirect Nunchucks',
        :customer_reference => Time.now.to_f,
        :billing_reference => Time.now.to_f
      }
    )

    if @transaction.failed?
      redirect_to transparent_redirect_payment_form_path(payment_method_params) and return
    end

    redirect_to transparent_redirect_receipt_path
  end


  # Purchase confirmation & receipt page
  # ------------------------------------
  def receipt
  end

end
