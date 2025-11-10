defmodule Nasa.Domain.CalculateFuel do
  @moduledoc """
  Calculates required fuel
  """
  @doc """
  Calculates required launch fuel for a object.

  ## Parameteres

      * `mass` - object mass
      * `gravity` - planet gravity

  ## Examples

      iex> Nasa.Domain.CalculateFuel.launch([mass: Decimal.new("28801"), gravity: Decimal.new("9.807")])
      Decimal.new("11830")
  """
  @spec launch(mass: Decimal.t(), gravity: Decimal.t()) :: integer()
  def launch(mass: %Decimal{} = mass, gravity: %Decimal{} = gravity) do

    case check_params(Application.get_env(:nasa, :launch, values: ["0.042", "33"])[:values]) do
      [param1: param1, param2: param2] ->
      Decimal.Context.with(%Decimal.Context{rounding: :floor}, fn ->
        mass
        |> Decimal.mult(gravity)
        |> Decimal.mult(param1)
        |> Decimal.sub(param2)
        |> Decimal.round()
      end)
      {:error, message} -> {:error, message}
    end
  end

  defp check_params([param1, param2]) do
    try do
      [param1: Decimal.new(param1), param2: Decimal.new(param2)]
    rescue
      error in Decimal.Error -> {:error, "Launch parameters configuration error: #{Exception.message(error)}"}
    end
  end
end
