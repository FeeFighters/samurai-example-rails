module ApplicationHelper
  def markdown(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    syntax_highlighter(Redcarpet.new(text, *options).to_html).html_safe
  end
  
  def syntax_highlighter(html)
    doc = Nokogiri::HTML(html)
    doc.search("//pre[@lang]").each do |pre|
      pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
    end
    doc.to_s
  end

  #
  # Here we fake authentication against a User account model, storing the user_id in the session
  #
  def current_user
    @current_user ||= User.find(session[:user_id])  # if the user exists already, find it
    @current_user ||= User.create.tap do |user|  # if it doesn't exist yet, create one and store it in the session
      session[:user_id] = user.id
    end
  end
end
