defmodule PhxBlogWeb.Router do
  use PhxBlogWeb, :router

  import PhxBlogWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PhxBlogWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhxBlogWeb do
    pipe_through :browser

    live "/", PageLive, :index
    resources "/posts", PostController, except: [:index] do
      resources "/comments", CommentController
    end
    live "/posts", PostLive.Index
  end

#  scope "/", PhxBlogWeb do
#    pipe_through :browser
#
#    get "/posts/:id", PostController, :show
#
#    get "/posts/:post_id/comments", CommentController, :index
#
#    live "/posts_live", PostLive.Index
#  end
#
#  scope "/", PhxBlogWeb do
#    pipe_through [:browser, :require_authenticated_user]
#
#    post "/posts", PostController, :create
#    get "/posts", PostController, :new
#    get "/posts/:id", PostController, :edit
#    put "/posts/:id", PostController, :update
#    delete "/posts/:id", PostController, :delete
#
#    post "/posts/:post_id/comments", CommentController, :create
#    get "/posts/:post_id/comments", CommentController, :new
#    get "/posts/:post_id/comments/:id", CommentController, :edit
#    put "/posts/:post_id/comments/:id", CommentController, :update
#  end

  # Other scopes may use custom stacks.
  # scope "/api", PhxBlogWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: PhxBlogWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", PhxBlogWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/login", UserSessionController, :new
    post "/users/login", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", PhxBlogWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", PhxBlogWeb do
    pipe_through [:browser]

    delete "/users/logout", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
