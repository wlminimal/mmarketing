defmodule MmarketingWeb.PhoneVerifyController do
	use MmarketingWeb, :controller
	alias Mmarketing.Account.Helpers

	def new(conn, params) do
		case get_session(conn, :user_id) do
			{:error, _}     ->
				conn
				|> redirect(to: sign_in_path(conn, :new))
				|> halt()
			user_id ->
				user = Helpers.get_user_by_id(user_id)
				render(conn, "new.html", conn: conn, user: user)
		end
		
	end

	def create(conn, %{"phone_verify" => params = %{"phone_number" => phone_number}}) do
		# Create login link and add phone number to database.
		render(conn, "new.html")
	end
end