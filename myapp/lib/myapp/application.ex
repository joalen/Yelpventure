defmodule Myapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    mongo_url = System.get_env("MONGO_DB_URL")
    mongo_name = System.get_env("MONGO_DB_NAME")
    children = [
      {DNSCluster, query: Application.get_env(:myapp, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Myapp.PubSub},
      {Finch, name: LocalQuestFinch},
      {Mongo, [name: :mongo, url: mongo_url, database: mongo_name, pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5"), ssl: true, ssl_opts: [verify: :verify_none]]},
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
