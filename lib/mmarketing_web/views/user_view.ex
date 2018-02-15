defmodule MmarketingWeb.UserView do
  use MmarketingWeb, :view

  def first_name(user) do
    user.first_name
  end
end
