defmodule LocalQuest.QuestContext do
  @moduledoc """
  Creates the "context" portion of Yelpventure for quests and player progress.
  """
  alias LocalQuest.{Player, Quest}

  @doc "Complete a quest and award XP/badges"
  def complete_quest(user_id, quest_id) do
    with {:ok, quest} <- Quest.get(quest_id),
         {:ok, result} <- Player.complete_quest(user_id, quest_id, quest["xp_reward"]) do

      check_and_award_badges(user_id)
      {:ok, Map.put(result, :quest_title, quest["title"])}
    end
  end

  @doc "Get player's progress summary"
  def get_progress(user_id) do
    with {:ok, player} <- Player.get(user_id) do
      available = Quest.list_available(user_id)

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
  def get_by_category(user_id, category) do
    {:ok, player} = Player.get(user_id)

    Mongo.find(:mongo, "challenges", %{
      "categories" => category,
      "_id" => %{"$nin" => player["completed_quests"]}
    })
    |> Enum.to_list()
  end

  defp check_and_award_badges(user_id) do
    {:ok, player} = Player.get(user_id)
    completed = length(player["completed_quests"])
    badges = player["badges"]

    cond do
      completed >= 50 and "legendary" not in badges ->
        Player.award_badge(user_id, "legendary")
      completed >= 25 and "expert" not in badges ->
        Player.award_badge(user_id, "expert")
      completed >= 10 and "veteran" not in badges ->
        Player.award_badge(user_id, "veteran")
      completed >= 5 and "adventurer" not in badges ->
        Player.award_badge(user_id, "adventurer")
      completed >= 1 and "novice" not in badges ->
        Player.award_badge(user_id, "novice")
      true -> :ok
    end
  end
end
