defmodule Cfsjksas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    # some helper doc
    IO.inspect("Cfsjksas.Chart.Circle.main(\"circle.svg\")")
    IO.inspect("Cfsjksas.Chart.CircleMod.main(\"circle_mod.svg\")")
    IO.inspect("Cfsjksas.Tools.Markdown.person_pages(:all)")
    IO.inspect("clean up removing extras below in children")


    children = [
      CfsjksasWeb.Telemetry,
      Cfsjksas.Repo,
      {DNSCluster, query: Application.get_env(:cfsjksas, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Cfsjksas.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Cfsjksas.Finch},
      # start the Agents for storing data
      Cfsjksas.Ancestors.StoreAncestor,
      Cfsjksas.Ancestors.StoreLinesToIdA,
      Cfsjksas.Ancestors.StoreIdAToLines,
#      Cfsjksas.Ancestors.StoreMarked,
      Cfsjksas.Ancestors.StoreMarkedSectors,
#      Cfsjksas.Ancestors.StoreRelationMap,
      # start some dev counters
      Cfsjksas.DevTools.StoreCountPeople,
      Cfsjksas.DevTools.StoreNoChildMap,
      Cfsjksas.DevTools.StoreChildNoWerelate,
      Cfsjksas.DevTools.StoreChildNoWerelateList,
      Cfsjksas.DevTools.StoreLinkAlready,
      Cfsjksas.DevTools.StoreNoFather,
      Cfsjksas.DevTools.StoreNoMother,
      Cfsjksas.DevTools.StoreUpdatingLink,
      Cfsjksas.DevTools.StoreNoLinkYet,
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
