defmodule Ezmodex do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      Plug.Adapters.Cowboy.child_spec(
        :http,
        Application.get_env(:ezmodex, :router),
        [],
        [port: Application.get_env(:ezmodex, :port)]
      )
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end

end
