defmodule Nasa.Domain.Launch.CalculateFuel do
  @moduledoc """
  Calculates required launching fuel
  """
  alias Nasa.Domain.CalculateFuel
  alias Nasa.Domain.Util

  @doc """
  Calculates required launch fuel for a object.

  ## Parameteres

      * `mass` - object mass
      * `gravity` - planet gravity

  ## Examples

      iex> Nasa.Domain.Launch.CalculateFuel.launch([mass: Decimal.new("28801"), gravity: Decimal.new("9.807")])
      Decimal.new("19772")
  """
  @spec launch(mass: Decimal.t(), gravity: Decimal.t()) :: integer() | {:error, binary()}
  def launch(mass: %Decimal{} = mass, gravity: %Decimal{} = gravity) do
    case Util.check_params(Application.get_env(:nasa, :launch, values: ["0.042", "33"])[:values]) do
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
