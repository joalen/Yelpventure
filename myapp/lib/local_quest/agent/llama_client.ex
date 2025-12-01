defmodule LocalQuest.Agent.LLAMAClient do
  alias LocalQuest.Agent.LLAMAClient
    @base_url "https://api.groq.com/openai/v1/chat/completions"

    def api_key do
        Application.get_env(:myapp, :groq_api_key) ||
            raise """
            Environment variable GROQ_API_KEY is missing!
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

    def generate(prompt) do
      headers = [
        {"Authorization", "Bearer #{api_key()}"},
        {"Content-Type", "application/json"}
      ]

      body = Jason.encode!(%{
        model: "llama-3.3-70b-versatile",
        messages: [
          %{
            role: "user",
            content: prompt
          }
        ]
      })

      request = Finch.build(:post, @base_url, headers, body)
      case Finch.request(request, LocalQuestFinch) do
        {:ok, %Finch.Response{status: 200, body: response_body}} ->
          {:ok, decoded} = Jason.decode(response_body)
          text = get_in(decoded, ["choices", Access.at(0), "message", "content"])
          {:ok, text}
        {:ok, %Finch.Response{status: code}} ->
          {:error, "Inference Model returned status #{code}"}
        {:error, reason} ->
          {:error, reason}
      end
    end

    def generate_challenges(conn) do
      base_prompt = Utilities.MarkdownConversion.plain_text("priv/static/assets/prompts.md")

      categories = Mongo.find(conn, "categories", %{}) |> Enum.to_list()
      category_slugs = Enum.map(categories, & &1["slug"])
      recent_challenges = Mongo.find(conn, "challenges", %{}, sort: %{created_at: -1}, limit: 20)
      |> Enum.to_list()
      |> Enum.map(fn c ->
        %{
          "title" => c["title"],
          "categories_used" => c["categories"]
        }
      end)

      full_prompt = """
      #{base_prompt}

      ---

      ## CURRENT DATA:

      **Available Categories:**
      #{Jason.encode!(category_slugs, pretty: true)}

      **Recent Challenges (to avoid):**
      #{Jason.encode!(recent_challenges, pretty: true)}

      **User Level:** Novice (for now, can be dynamic later)

      Generate ONE new unique challenge now.
      """

      case LLAMAClient.generate(full_prompt) do
        {:ok, generated_text} ->
          json_text = Utilities.MarkdownConversion.extract_json(generated_text)

          full_response = Jason.decode!(json_text)
          challenge = full_response["challenge"]

          Mongo.insert_one(conn, "challenges", challenge)

        {:error, err} ->
          {:error, err}
      end
    end
end
