defmodule LocalQuestWeb.PlayerController do
  use LocalQuestWeb, :controller
  alias LocalQuest.{Player, QuestContext}

  def create(conn, %{"user_id" => user_id}) do
    Player.create(get_mongo(conn), user_id)
    json(conn, %{success: true})
  end

  def show(conn, %{"user_id" => user_id}) do
    {:ok, player} = Player.get(get_mongo(conn), user_id)
    json(conn, player)
  end

  def progress(conn, %{"user_id" => user_id}) do
    {:ok, progress} = QuestContext.get_progress(get_mongo(conn), user_id)
    json(conn, progress)
  end

  defp get_mongo(conn), do: conn.assigns.mongo
end
