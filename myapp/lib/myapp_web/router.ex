defmodule MyappWeb.Router do
  use MyappWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MyappWeb do
  pipe_through :api

  # Player endpoints
  post "/players", PlayerController, :create
  get "/players/:user_id", PlayerController, :show
  get "/players/:user_id/progress", PlayerController, :progress

  # Quests endpoints
  get "/quests/available/:user_id", QuestController, :available
  get "/quests/nearby", QuestController, :nearby
  post "/quests/:quest_id/complete", QuestController, :complete

  # Leaderboard endpoint
  get "/leaderboard", LeaderboardController, :index

  # locations endpoint (helps populate "pins" to put on the map)
  get "/quests/locations", QuestController, :locations
  end
end
