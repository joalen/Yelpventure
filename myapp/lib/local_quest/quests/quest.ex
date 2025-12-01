defmodule LocalQuest.Quest do
  @moduledoc """
  Since this game is more "Pokemon Go" style, quests are
  just fetched challenges from a master list that users can have
  and are random with heuristics based on location, geography, etc.
  """

  @collection "challenges"

  @doc "Fetches all available challenges the user can do from the master list"
  def list_available(conn, user_id) do
    {:ok, player} = LocalQuest.Player.get(conn, user_id)
    completed_ids = player["completed_quests"]

    # Get all challenges not yet completed
    Mongo.find(conn, @collection, %{
      "_id" => %{"$nin" => completed_ids}
    })
    |> Enum.to_list()
  end

  @doc "Fetches a specific quest by its ID (id being MongoDB's auto-populated one) from the master list"
  def get(conn, quest_id) do
    case Mongo.find_one(conn, @collection, %{"_id" => quest_id}) do
      nil -> {:error, :not_found}
      quest -> {:ok, quest}
    end
  end
end
