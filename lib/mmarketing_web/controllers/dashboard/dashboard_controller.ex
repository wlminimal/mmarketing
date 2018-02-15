defmodule MmarketingWeb.Dashboard.DashboardController do
	use MmarketingWeb, :controller

	def new(conn, _) do
		conn
		|> render("new.html")
	end
end