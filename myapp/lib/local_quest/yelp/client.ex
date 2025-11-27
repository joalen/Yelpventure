defmodule LocalQuest.Yelp.Client do
    @base_url "https://api.yelp.com/ai/chat/v2"

    def api_key do
        Application.get_env(:myapp, :yelp_api_key) ||
          raise """
          Environment variable YELP_API_KEY is missing!
          Make sure it is set in your shell or in a .env file.
          """
    end

    def retrieve_query(lat, lng, queryText) do
        headers = [{"Authorization", "Bearer #{api_key()}"}, {"Content-Type", "application/json"}]

        body =
        %{
            user_context: %{
                latitude: lat,
                longitude: lng
            },
            request_context: %{
                skip_text_generation: false
            },
            query: queryText
        } |> Jason.encode!()

        request = Finch.build(:post, @base_url, headers, body)
        case Finch.request(request, LocalQuestFinch) do
          {:ok, %Finch.Response{status: 200, body: body}} -> Jason.decode(body)
          {:ok, %Finch.Response{status: code}} -> {:error, "Yelp API returned a status code #{code}"}
          {:error, reason} -> {:error, reason}
        end
    end
end
