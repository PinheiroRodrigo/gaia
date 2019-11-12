defmodule Gaia do
  use Application

    def start(_type, _args) do
      children = [
        Plug.Cowboy.child_spec(
          scheme: :http,
          plug: Gaia.Router,
          options: [
            dispatch: dispatch(),
            port: 4000,
            timeout: :infinity
          ]
        ),
        Registry.child_spec(
          keys: :duplicate,
          name: Registry.Gaia
        ),
        {Gaia.Repo, []}
      ]

      opts = [strategy: :one_for_one, name: Gaia.Application]
      Supervisor.start_link(children, opts)
    end

    defp dispatch do
      [
        {:_,
          [
            {"/ws/[...]", Gaia.SocketHandler, []},
            {:_, Plug.Cowboy.Handler, {Gaia.Router, []}}
          ]
        }
      ]
    end

end
