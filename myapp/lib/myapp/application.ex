defmodule Myapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    project_root = File.cwd!()
    dotenv_path = Path.join(project_root, ".env")

    if File.exists?(dotenv_path) do
      Dotenvy.source!(dotenv_path)
    else
      IO.puts(".env file not found at #{dotenv_path}, proceeding without loading environment variables from it.")
    end

    children = [
      MyappWeb.Telemetry,
      # Myapp.Repo,
      {DNSCluster, query: Application.get_env(:myapp, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Myapp.PubSub},
      {Finch, name: LocalQuestFinch},
      # Start a worker by calling: Myapp.Worker.start_link(arg)
      # {Myapp.Worker, arg},
      # Start to serve requests, typically the last entry
      MyappWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Myapp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MyappWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
