scope "/api", LocalQuestWeb do
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

  # generating points
  post "/quests/generate", QuestController, :generate
end

pipeline :api do
  plug :accepts, ["json"]
  plug :put_mongo
end

defp put_mongo(conn, _opts) do
  assign(conn, :mongo, :mongo)
end
