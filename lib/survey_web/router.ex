defmodule SurveyWeb.Router do
  use SurveyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SurveyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SurveyWeb do
    pipe_through :browser

    # get "/", PageController, :home
    live "/", SurveyLive.Index, :index
    live "/polls", SurveyLive.Index, :index
    live "/polls/new", SurveyLive.NewPoll, :new
    live "/polls/:id", SurveyLive.ShowPoll, :show
    live "/polls/:id/results", SurveyLive.ResultsPoll, :show
    live "/polls/:id/edit", SurveyLive.EditPoll, :edit
    # live "/polls/:id/delete", SurveyLive.DeletePoll, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", SurveyWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:survey, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SurveyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
