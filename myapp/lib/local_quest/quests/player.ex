defmodule LocalQuest.Player do
  @moduledoc """
  Player progress management with MongoDB
  """

  @collection "players"

  @doc "Create new player"
  def create(user_id) do
    player = %{
      "user_id" => user_id,
      "xp" => 0,
      "level" => 1,
      "completed_quests" => [],
      "badges" => [],
      "created_at" => DateTime.utc_now(),
      "updated_at" => DateTime.utc_now()
    }

    Mongo.insert_one(:mongo, @collection, player)
  end

  @doc "Get player by user_id"
  def get(user_id) do
    case Mongo.find_one(:mongo, @collection, %{"user_id" => user_id}) do
      nil -> {:error, :not_found}
      player -> {:ok, player}
    end
  end

  @doc "Award XP and handle leveling (XP depends on quest weight)"
  def award_xp(user_id, xp_amount) do
    with {:ok, player} <- get(user_id) do
      new_xp = player["xp"] + xp_amount
      new_level = div(new_xp, 100) + 1

      update = %{
        "$set" => %{
          "xp" => new_xp,
          "level" => new_level,
          "updated_at" => DateTime.utc_now()
        }
      }

      Mongo.update_one(:mongo, @collection, %{"user_id" => user_id}, update)
      {:ok, %{xp: new_xp, level: new_level, leveled_up: new_level > player["level"]}}
    end
  end

  @doc "Mark quest as completed"
  def complete_quest(user_id, quest_id, xp_reward) do
    with {:ok, player} <- get(user_id) do
      if quest_id in player["completed_quests"] do
        {:error, :already_completed}
      else
        update = %{
          "$push" => %{"completed_quests" => quest_id},
          "$set" => %{"updated_at" => DateTime.utc_now()}
        }

        Mongo.update_one(:mongo, @collection, %{"user_id" => user_id}, update)
        award_xp(user_id, xp_reward)
      end
    end
  end

  @doc "Award badge"
  def award_badge(user_id, badge_name) do
    update = %{
      "$addToSet" => %{"badges" => badge_name},
      "$set" => %{"updated_at" => DateTime.utc_now()}
    }

    Mongo.update_one(:mongo, @collection, %{"user_id" => user_id}, update)
  end

  @doc "Get leaderboard (top N players by XP)"
  def leaderboard(limit \\ 10) do
    Mongo.find(:mongo, @collection, %{}, sort: %{xp: -1}, limit: limit)
    |> Enum.to_list()
  end
end
