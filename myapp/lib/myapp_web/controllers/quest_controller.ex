defmodule LocalQuestWeb.QuestController do
  use LocalQuestWeb, :controller
  alias LocalQuest.{Quest, QuestContext}

  def available(conn, %{"user_id" => user_id}) do
    quests = Quest.list_available(get_mongo(conn), user_id)
    json(conn, %{quests: quests})
  end

  def nearby(conn, %{"lat" => lat, "lng" => lng, "user_id" => user_id}) do
    # Filter quests by distance (add geo logic later)
    quests = Quest.list_available(get_mongo(conn), user_id)
    json(conn, %{quests: quests})
  end

  def complete(conn, %{"quest_id" => quest_id, "user_id" => user_id}) do
    case QuestContext.complete_quest(get_mongo(conn), user_id, quest_id) do
      {:ok, result} -> json(conn, result)
      {:error, reason} ->
        conn |> put_status(400) |> json(%{error: reason})
    end
  end

  defp get_mongo(_conn), do: Process.get(:mongo_conn)
end
