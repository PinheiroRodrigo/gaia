defmodule Gaia.SocketHandler do
  @behaviour :cowboy_websocket

  def init(request, _state) do
    IO.inspect "Request"
    IO.inspect request
    state = %{registry_key: request.path}
    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Registry.register(Registry.Gaia, state.registry_key, {})
    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
    IO.inspect "Json"
    IO.inspect json
    IO.inspect "State"
    IO.inspect state
    payload = Jason.decode!(json)
    message = payload["data"]["message"]

    Registry.dispatch(Registry.Gaia, state.registry_key, fn(entries) ->
      for {pid, _} <- entries do
        if pid != self() do
          Process.send(pid, message, [])
        end
      end
    end)

    {:reply, {:text, message}, state}
  end

  def websocket_info(info, state) do
    IO.inspect "Info"
    IO.inspect info
    IO.inspect "State"
    IO.inspect state
    {:reply, {:text, info}, state}
  end

end
