defmodule Nasa.Domain.Land.CalculateFuel do
  @moduledoc """
  Calculates required landing fuel
  """
  alias Nasa.Domain.CalculateFuel
  alias Nasa.Domain.Util

  @doc """
  Calculates required land fuel for a object.

  ## Parameteres

      * `mass` - object mass
      * `gravity` - planet gravity

  ## Examples

      iex> Nasa.Domain.Land.CalculateFuel.land([mass: Decimal.new("28801"), gravity: Decimal.new("9.807")])
      Decimal.new("13447")
  """
  @spec land(mass: Decimal.t(), gravity: Decimal.t()) :: integer() | {:error, binary()}
  def land(mass: %Decimal{} = mass, gravity: %Decimal{} = gravity) do
    case Util.check_params(Application.get_env(:nasa, :land, values: ["0.033", "42"])[:values]) do
      [param1: param1, param2: param2] ->
        CalculateFuel.calculate(
          mass: mass,
          gravity: gravity,
          param1: param1,
          param2: param2,
          total: Decimal.new("0")
        )

      {:error, message} ->
        {:error, message}
    end
  end
end
