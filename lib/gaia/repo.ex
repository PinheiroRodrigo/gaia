defmodule Gaia.Repo do
  use Ecto.Repo,
    otp_app: :gaia,
    adapter: Ecto.Adapters.Postgres
end
