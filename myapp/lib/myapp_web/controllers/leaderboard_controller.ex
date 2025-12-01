defmodule LocalQuestWeb.LeaderboardController do
  use LocalQuestWeb, :controller
  alias LocalQuest.Player

  def index(conn, params) do
    limit = Map.get(params, "limit", "10") |> String.to_integer()
    leaderboard = Player.leaderboard(get_mongo(conn), limit)

    json(conn, %{leaderboard: leaderboard})
  end

  defp get_mongo(_conn), do: Process.get(:mongo_conn)
end
