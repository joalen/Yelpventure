defmodule LocalQuest.Agent.QwenClient do
    @api_url "https://api-inference.huggingface.co/models/Qwen/Qwen-2.5-7B"

    def api_key do
        Application.get_env(:myapp, :hf_api_token) ||
            raise """
            Environment variable YELP_API_KEY is missing!
            Make sure it is set in your shell or in a .env file.
            """
    end

    def summarize_completed_challenges() do
        # invokes the QwenClient API to summarize challenges (helps save on tokens for completed challenges)

    end

    def generate_quest() do
        # invoking the QwenClient API to create a random quest that the user can do (of course depends on factors like age, sex, etc)
        # from there, Qwen returns a response back


    end

    def generate_challenge(business_data) do
        # after we hit Yelp AI API's payload, take that and create an engaging challenge that the user can play
    end
end
