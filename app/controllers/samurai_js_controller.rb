class SamuraiJsController < ApplicationController

  # Payment form for Samurai.js
  # ------------------------------
  #
  # * displays a drop-in payment form from Samurai.js, no extra logic required
  def payment_form
  end

  # Purchase action for Samurai.js
  # ------------------------------
  #
  # * payment_method_token is POST'd via AJAX
  # * Responds with a JSON transaction object
  #
  def purchase
    respond_to do |format|
      format.json do
        @transaction = Samurai::Processor.the_processor.purchase(
          params[:payment_method_token],
          122.00,  # The price for the Samurai.js Katana Sword
          {
            :descriptor => 'Samurai.js Katana Sword',
            :customer_reference => Time.now.to_f,
            :billing_reference => Time.now.to_f
          }
        )

        render :json => @transaction
      end
    end
  end

  # Purchase confirmation & receipt page
  # ------------------------------------
  def receipt
  end

end
