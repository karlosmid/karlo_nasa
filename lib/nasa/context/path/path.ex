defmodule Nasa.Context.Path do
  @moduledoc """
  Changeset for path form
  """
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key false

  embedded_schema do
    field(:mass, :decimal)
    field(:action, :string)
    field(:planet, :string)
  end

  def changeset(path, attrs) do
    path
    |> cast(attrs, [:mass, :action, :planet])
    |> validate_required([:mass, :action, :planet])
    |> validate_inclusion(:action, ["land", "launch"])
    |> validate_inclusion(:planet, ["earth", "moon", "mars"])
    |> validate_change(:mass, fn :mass, mass ->
      try do
        Decimal.new(mass)
        []
      rescue
        _error in Decimal.Error ->
          [mass: "must be a number"]
      end
    end)
  end

  def change_path(path, attrs \\ %{}) do
    changeset(path, attrs)
  end
end
