defmodule MmarketingWeb.UserController do
  use MmarketingWeb, :controller
  alias Mmarketing.Account.{User, Helpers}
  alias Mmarketing.Mailer
  alias MmarketingWeb.Email

  def new(conn, _params) do
    render(conn, "new.html", changeset: User.changeset(%User{}))
  end

  # User sign up using form
  def create(conn, %{"register" => params = %{"email" => email}}) do
    case Helpers.get_user_by_email(email) do
      nil ->
        changeset = User.changeset(%User{}, params)
        case changeset.valid? do
          true ->
            case Helpers.insert_user(changeset) do
              {:ok, user} ->
                # forward to phone verification page
                conn
                |> put_session(:user_id, user.id)
                |> configure_session(renew: true)
                |> redirect(to: phone_verify_path(conn, :new))
              {:error, _} ->
                conn
                |> put_flash(:error, "Can't sign up, try again!")
                |> render(:new, changeset: changeset)
            end

            # # Forward to Choose a plan page pass with changeset
            # case Helpers.insert_user(changeset) do
            # {:ok, user} ->
            #   # Send email for login link (Welcome Email)
            #   # Create token and link here
            #   token = Helpers.generate_token(user)
            #   link = sign_in_url(conn, :create, token)
            #   welcome(conn, user, link)
            # {:error, _} ->
            #   conn
            #   |> put_flash(:error, "Can't sign up, try again!")
            #   |> render(:new, changeset: changeset)
            # end
          _ ->
            conn
              |> put_flash(:error, "Oops Something wrong! Try Again!")
              |> render(:new,  changeset: changeset)
        end
        
      user ->
        conn
        |> put_flash(:error, "You are already registered with this email. Please sign in")
        |> redirect(to: sign_in_path(conn, :new))
    end
  end

  # def create(conn, %{"register" => params = %{"email" => email}}) do
  #   case Helpers.get_user_by_email(email) do
  #     nil ->
  #
  #     user ->
  #       conn
  #       |> put_flash(:error, "You are already registered with this email. Please sign in")
  #       |> redirect(to: sign_in_path(conn, :new))
  #   end
  # end

  defp welcome(conn, user, link) do
    Email.welcome(user, link) |> Mailer.deliver_later
    conn
    |> put_flash(:info, "Only one step left! Check your inbox for a confirmation email.")
    |> redirect(to: page_path(conn, :index))
  end
end
