defmodule Gaia.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :message, :string

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message])
    |> validate_required([:message])
  end
end
