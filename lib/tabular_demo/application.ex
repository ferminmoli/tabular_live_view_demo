defmodule TabularDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TabularDemoWeb.Telemetry,
      TabularDemo.Repo,
      {DNSCluster, query: Application.get_env(:tabular_demo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TabularDemo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TabularDemo.Finch},
      # Start a worker by calling: TabularDemo.Worker.start_link(arg)
      # {TabularDemo.Worker, arg},
      # Start to serve requests, typically the last entry
      TabularDemoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TabularDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TabularDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
