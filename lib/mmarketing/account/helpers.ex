defmodule Mmarketing.Account.Helpers do
  import Ecto.Query
  alias Mmarketing.Repo
  alias Mmarketing.Account.User
  alias Payment
  alias Messageman


  def get_or_insert_user(changeset) do
    case get_user_by_email(changeset.changes.email) do
      nil ->
        insert_user(changeset)
      user ->
        {:ok, user}
    end
  end

  # insert a user and create a stripe account and twilio account

  def insert_user(changeset) do
    changeset
    |> Repo.insert()
  end

  def get_user_by_id(id) do
    Repo.one(from u in User, where: u.id == ^id)
  end

  def get_user_by_email(email) do
    Repo.one(from u in User, where: u.email == ^email)
  end

  # passwordless login... generate_toke!
  def generate_token(user) do
    token = Phoenix.Token.sign(MmarketingWeb.Endpoint, "user", user.id)
    token
  end

  @max_age 600 # 10 min
  def verify_token(token) do
    Phoenix.Token.verify(MmarketingWeb.Endpoint, "user", token, max_age: @max_age)
  end

  # Make a customer for Stripe and subscribe to free plan
  # TODO : Add more stripe data to User
  def create_stripe_customer_and_subscribe_to_plan(changeset) do
    email = changeset.changes.email
    key = Payment.get_key()
    {:ok, %{id: stripe_id} } = Payment.create_customer([email: email], key)
    Payment.create_subscription(stripe_id, [plan: "free"], key)
    Ecto.Changeset.change(changeset, %{stripe_id: stripe_id, plan: "free"})
  end

  def create_twilio_subaccount(changeset) do
    email = changeset.changes.email
    { sid, token, friendly_name } = Messageman.create_account(email)
    Ecto.Changeset.change(changeset, %{twilio_sid: sid, twilio_token: token})
  end

  def create_messaging_service(changeset) do
    account = changeset.changes.twilio_sid
    token = changeset.changes.twilio_token
    friendly_name = changeset.changes.email
    messaging_service_sid = Messageman.create_messaging_service({account, token, friendly_name})
    Ecto.Changeset.change(changeset, %{twilio_msid: messaging_service_sid})
  end
end
