defmodule MmarketingWeb.Plugs.DashboardLayout do
	import Phoenix.Controller, only: [put_layout: 2]

	def init(_opts), do: nil

	def call(conn, _) do
		conn
		|> put_layout({MmarketingWeb.LayoutView, "app_dashboard.html"})
	end
end