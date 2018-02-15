defmodule MmarketingWeb.Email do
  use Bamboo.Phoenix, view: MmarketingWeb.EmailView

  # When user first sign up
  def welcome(user, link) do
    gatebot_email()
    |> to(user)
    |> subject("Welcome! Confirm Your Address")
    |> assign(:user, user)
    |> assign(:link, link)
    |> render(:welcome)
  end

  # When user sign in via email or OAuth
  def sign_in(user, link) do
    gatebot_email()
    |> to(user)
    |> subject("Your Sign In Link")
    |> assign(:user, user)
    |> assign(:link, link)
    |> render(:sign_in)
  end

  defp gatebot_email() do
    new_email()
    |> from("gatebot@minimalmarketing.io")
    |> put_header("Reply-To", "info@minimalmarketing.io")
    |> put_html_layout({MmarketingWeb.LayoutView, "email_gatebot.html"})
  end
end

defimpl Bamboo.Formatter, for: Mmarketing.Account.User do
  def format_email_address(user, _opts) do
    { user.first_name, user.email }
  end
end
