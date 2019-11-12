defmodule Gaia.SocketHandler do
  @behaviour :cowboy_websocket

  alias Gaia.{Message, Repo}

  def init(request, _state) do
    state = %{registry_key: request.path}
    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Registry.register(Registry.Gaia, state.registry_key, {})
    # Render old messages
    Process.send(self(), get_messages(), [])
    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
    payload = Jason.decode!(json)
    time = Time.utc_now |> Time.to_string
    user = payload["data"]["user"]
    body = payload["data"]["message"]
    message = "[#{time}] #{user}: #{body}"
    # Persist message
    Repo.insert!(%Message{message: message})
    # Broadcast
    messages = get_messages()
    Registry.dispatch(Registry.Gaia, state.registry_key, fn(entries) ->
      for {pid, _} <- entries do
        if pid != self() do
          Process.send(pid, messages, [])
        end
      end
    end)
    {:reply, {:text, messages}, state}
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end

  def get_messages do
    Repo.all(Message)
    |> Enum.map(&(&1.message))
    |> Jason.encode
    |> elem(1)
  end

end
