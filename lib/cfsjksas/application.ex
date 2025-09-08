defmodule Cfsjksas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CfsjksasWeb.Telemetry,
      Cfsjksas.Repo,
      {DNSCluster, query: Application.get_env(:cfsjksas, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Cfsjksas.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Cfsjksas.Finch},
      # start the 3 Agents for storing data
      Cfsjksas.Ancestors.StoreAncestor,
      Cfsjksas.Ancestors.StoreMarked,
      Cfsjksas.Ancestors.StoreRelationMap,
      # start some dev counters
      Cfsjksas.DevTools.StoreLinkAlready,
      Cfsjksas.DevTools.StoreNoFather,
      Cfsjksas.DevTools.StoreNoMother,
      Cfsjksas.DevTools.StoreUpdatingLink,
      Cfsjksas.DevTools.StoreNoLinkYet,
      Cfsjksas.DevTools.StoreCountPeople,
      Cfsjksas.DevTools.StoreNilPerson,
      # Start a worker by calling: Cfsjksas.Worker.start_link(arg)
      # {Cfsjksas.Worker, arg},
      # Start to serve requests, typically the last entry
      CfsjksasWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cfsjksas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CfsjksasWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
