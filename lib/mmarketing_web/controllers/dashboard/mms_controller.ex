defmodule MmarketingWeb.Dashboard.MmsController do
	use MmarketingWeb, :controller

	def new(conn, _) do
		render(conn, "new.html")
	end

	def create(conn, params) do
		render(conn, "new.html")
	end
end