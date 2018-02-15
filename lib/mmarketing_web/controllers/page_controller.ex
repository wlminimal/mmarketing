defmodule MmarketingWeb.PageController do
  use MmarketingWeb, :controller
  alias Payment
  alias Payment.Customers

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create_customer(conn, params) do
    email = params["stripe_customer"]["email"]
    key = Payment.get_key()
    Customers.create_customer([email: email], key)
    render conn, "index.html"
  end
end
