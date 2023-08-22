defmodule Bhrama.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BhramaWeb.Telemetry,
      # Start the Ecto repository
      Bhrama.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bhrama.PubSub},
      # Start Finch
      {Finch,
       name: Bhrama.Finch,
       pools: %{
         :default => [
           size: 20,
           pool_max_idle_time: 560_000,
           conn_max_idle_time: 560_000
         ]
       }},
      # Start the Endpoint (http/https)
      BhramaWeb.Endpoint
      # Start a worker by calling: Bhrama.Worker.start_link(arg)
      # {Bhrama.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bhrama.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BhramaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
