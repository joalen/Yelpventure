defmodule LocalQuest.QuestContext do
  @moduledoc """
  Creates the "context" portion of Yelpventure for quests and player progress.
  """
  alias LocalQuest.{Player, Quest}

  @doc "Complete a quest and award XP/badges"
  def complete_quest(conn, user_id, quest_id) do
    with {:ok, quest} <- Quest.get(conn, quest_id),
         {:ok, result} <- Player.complete_quest(conn, user_id, quest_id, quest["xp_reward"]) do

      check_and_award_badges(conn, user_id)
      {:ok, Map.put(result, :quest_title, quest["title"])}
    end
  end

  @doc "Get player's progress summary"
  def get_progress(conn, user_id) do
    with {:ok, player} <- Player.get(conn, user_id) do
      available = Quest.list_available(conn, user_id)

      {:ok, %{
        level: player["level"],
        xp: player["xp"],
        badges: player["badges"],
        completed_count: length(player["completed_quests"]),
        available_count: length(available)
      }}
    end
  end

  @doc "Get quests by category (for filtering on map)"
  def get_by_category(conn, user_id, category) do
    {:ok, player} = Player.get(conn, user_id)

    Mongo.find(conn, "challenges", %{
      "categories" => category,
      "_id" => %{"$nin" => player["completed_quests"]}
    })
    |> Enum.to_list()
  end

  defp check_and_award_badges(conn, user_id) do
    {:ok, player} = Player.get(conn, user_id)
    completed = length(player["completed_quests"])
    badges = player["badges"]

    cond do
      completed >= 50 and "legendary" not in badges ->
        Player.award_badge(conn, user_id, "legendary")
      completed >= 25 and "expert" not in badges ->
        Player.award_badge(conn, user_id, "expert")
      completed >= 10 and "veteran" not in badges ->
        Player.award_badge(conn, user_id, "veteran")
      completed >= 5 and "adventurer" not in badges ->
        Player.award_badge(conn, user_id, "adventurer")
      completed >= 1 and "novice" not in badges ->
        Player.award_badge(conn, user_id, "novice")
      true -> :ok
    end
  end
end
