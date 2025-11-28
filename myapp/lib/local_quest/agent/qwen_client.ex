defmodule LocalQuest.Agent.QwenClient do
    @base_url "https://router.huggingface.co/v1/chat/completions"

    def api_key do
        Application.get_env(:myapp, :hf_api_token) ||
            raise """
            Environment variable YELP_API_KEY is missing!
            Make sure it is set in your shell or in a .env file.
            """
    end

    def summarize(json) when is_binary(json) do
        case Jason.decode(json) do
          {:ok, decoded} -> summarize(decoded)
          {:error, err} -> {:error, {:invalid_json, err}}
        end
    end

    def summarize(%{"completed_challenges" => challenges}) do
        # We take the complete JSON completed_challenges payload and flatten it to just two fields: title and categories

        titles =
            challenges
            |> Enum.map(& &1["title"])
            |> Enum.uniq()

          categories =
            challenges
            |> Enum.flat_map(& &1["categories_used"])
            |> Enum.uniq()

          %{
            "titles" => titles,
            "categories_used" => categories
          }
    end

    def summarize(_other), do: {:error, :missing_completed_challenges}

    def generate_quest() do
        # invoking the QwenClient API to create a random quest that the user can do (of course depends on factors like age, sex, etc)
        # from there, Qwen returns a response back

    end

    def generate_challenge(business_data) do
        # after we hit Yelp AI API's payload, take that and create an engaging challenge that the user can play
    end
end
