defmodule MmarketingWeb.AuthController do
  use MmarketingWeb, :controller
  alias Mmarketing.Account.{User, Helpers}
  alias Mmarketing.Mailer
  alias MmarketingWeb.Email

  plug Ueberauth

  # OAuth from Google
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do

    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: provider,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name
    }
    #
    # IO.puts("+++++++++++++++++++++++++++++")
    # IO.inspect(user_params)
    # IO.puts("+++++++++++++++++++++++++++++")

    changeset = User.oauth_changeset(%User{}, user_params)

    case Helpers.get_or_insert_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: dashboard_path(conn, :new))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def callback(%{assigns: %{useberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Something went wrong.")
    |> render(conn, "")
  end

  # Sign in process using passwordless sign in

  def create(conn, %{"token" => token}) do
    case Helpers.verify_token(token) do
      {:ok, user_id} ->
        user = Helpers.get_user_by_id(user_id)
        conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "Successfully logged in!")
        |> redirect(to: dashboard_path(conn, :new))
      {:error, :invalid} ->
        conn
        |> put_flash(:error, "Invalid Link, Can't Log in")
        |> render("new.html")
      {:error, :expired} ->
        conn
        |> put_flash(:error, "Links has been expired. Please do it again")
        |> render("new.html")
    end
    conn
    |> redirect(to: page_path(conn, :index))
  end

  # When a user do "POST" request in sign in via email
  def new(conn, %{"auth" => %{"email" => email}}) do
    case Helpers.get_user_by_email(email) do
      nil ->
        conn
        |> put_flash(:error, "You have to sign up")
        # Redirect to signup page
        |> redirect(to: sign_up_path(conn, :new))
      user ->
        # Check if user's phone has been verified.
        case user.phone_verified do
          true ->
            token = Helpers.generate_token(user)
            link = sign_in_url(conn, :create, token)
            IO.puts("+++++++++++++++++++++++")
            IO.puts(link)
            IO.puts("+++++++++++++++++++++++")
            # Send email a link
            Email.sign_in(user, link) |> Mailer.deliver_later
            conn
            |> put_flash(:info, "We sent you an email link. Please check your email.")
            |> render(:new)

          _    ->
            conn
            |> put_flash(:error, "You have to verify your phone number!")
            |> put_session(:user_id, user.id)
            |> redirect(to: phone_verify_path(conn, :new))

        end
        # Create a link
        
    end
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def delete(conn, params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end
end
