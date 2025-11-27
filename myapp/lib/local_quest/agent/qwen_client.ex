defmodule LocalQuest.Agent.QwenClient do
  alias ElixirLS.LanguageServer.Application
    @api_url = "https://api-inference.huggingface.co/models/Qwen/Qwen-2.5-7B"
    @token Application.get_env(:myapp, :hf_api_token) ||
        raise """
        Environment variable HF_API_TOKEN is missing!
        Make sure it is set in your shell or in a .env file.
        """

    def generate_quest() do
        # invoking the QwenClient API to create a random quest that the user can do (of course depends on factors like age, sex, etc)
        # from there, Qwen returns a response back


    end

    def generate_challenge(business_data) do
        # after we hit Yelp AI API's payload, take that and create an engaging challenge that the user can play
    end
end
