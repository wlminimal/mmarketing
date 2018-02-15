defmodule Mmarketing.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :provider, :string
    field :token, :string
    field :stripe_id, :string
    field :twilio_sid, :string
    field :twilio_token, :string
    field :twilio_msid, :string
    field :phone_number, :string
    field :plan, :string
    field :phone_verified, :boolean

    timestamps()
  end

  def oauth_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :first_name, :last_name, :provider, :token, :stripe_id, 
      :twilio_sid, :twilio_token, :twilio_msid, :phone_number, :plan])
    |> validate_required([:email, :provider, :token])
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :first_name, :last_name, :stripe_id, 
      :twilio_sid, :twilio_token, :twilio_msid, :phone_number, :plan, :phone_verified])
    |> validate_required([:email, :first_name, :last_name])
    # |> validate_format(:phone_number, ~r/^[2-9]\d{2}-\d{3}-\d{4}$/)

  end


  defp string_to_phone_number(changeset) do
    case changeset.valid? do
      true ->
        phone_number_string = changeset.changes.phone_number
        case Integer.parse(phone_number_string) do
          :error ->
            add_error(changeset, :phone_number, "Please type number")
          _ ->
            phone_number = String.to_integer(phone_number_string)
            put_change(changeset, :phone_number, phone_number)
        end
      _ ->
        changeset
    end
  end
end
