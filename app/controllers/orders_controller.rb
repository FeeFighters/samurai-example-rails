class OrdersController < ApplicationController
  include Samurai::Rails::Helpers

  before_filter do
    @article = Article.find(params[:article_id])
  end

  # Create/Update a payment method via Samurai Transparent Redirect
  def new_payment_method
    params[:payment_method_token] ||= current_user.payment_method_token
    setup_for_transparent_redirect(params)
  end

  # Show the payment confirmation page
  def payment_confirmation
    load_and_verify_payment_method(params)
    redirect_to new_payment_method_article_orders_path(@article, payment_method_params) and return unless @payment_method

    current_user.update_attributes :payment_method_token=>@payment_method.token
  end

  # Create the new order, and redirect to the article
  def create
    load_and_verify_payment_method(params)
    @order = current_user.orders.create :article=>@article

    @transaction = Samurai::Processor.the_processor.purchase(
      @payment_method.token,
      @article.amount,
      {:descriptor => @article.name, :customer_reference => current_user.id, :billing_reference => @order.id}
    )

    if @transaction.failed?
      @order.destroy
      redirect_to new_payment_method_article_orders_path(@article, payment_method_params) and return
    end

    redirect_to article_path(@article), :notice=>'Thanks for purchase this article!'
  end
end
