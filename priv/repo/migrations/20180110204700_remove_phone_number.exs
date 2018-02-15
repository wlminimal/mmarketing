defmodule Mmarketing.Repo.Migrations.RemovePhoneNumber do
  use Ecto.Migration

  def change do
  	alter table(:users) do
  		remove :phone_number
  	end
  end
end
