defmodule Nasa.Domain.Launch.CalculateFuel do
  @moduledoc """
  Calculates required fuel
  """
  @doc """
  Calculates required launch fuel for a object.

  ## Parameteres

      * `mass` - object mass
      * `gravity` - planet gravity

  ## Examples

      iex> Nasa.Domain.Launch.CalculateFuel.launch([mass: Decimal.new("28801"), gravity: Decimal.new("9.807")])
      Decimal.new("19747")
  """
  @spec launch(mass: Decimal.t(), gravity: Decimal.t()) :: integer() | {:error, binary()}
  def launch(mass: %Decimal{} = mass, gravity: %Decimal{} = gravity) do
    case check_params(Application.get_env(:nasa, :launch, values: ["0.042", "33"])[:values]) do
      [param1: param1, param2: param2] ->
        fuel = calculate(mass: mass, gravity: gravity, param1: param1, param2: param2)

        do_launch(
          mass: fuel,
          gravity: gravity,
          param1: param1,
          param2: param2,
          total: fuel
        )

      {:error, message} ->
        {:error, message}
    end
  end

  defp calculate(mass: mass, gravity: gravity, param1: param1, param2: param2),
    do:
      Decimal.Context.with(%Decimal.Context{rounding: :floor}, fn ->
        mass
        |> Decimal.mult(gravity)
        |> Decimal.mult(param1)
        |> Decimal.sub(param2)
        |> Decimal.round()
        |> Decimal.to_integer()
      end)

  defp do_launch(mass: mass, gravity: gravity, param1: param1, param2: param2, total: total)
       when mass > 0 do
    fuel = calculate(mass: mass, gravity: gravity, param1: param1, param2: param2)

    do_launch(
      mass: fuel,
      gravity: gravity,
      param1: param1,
      param2: param2,
      total: Decimal.add(total, fuel)
    )
  end

  defp do_launch(mass: _mass, gravity: _gravity, param1: _param1, param2: _param2, total: total),
    do: total

  defp check_params([param1, param2]) do
    [param1: Decimal.new(param1), param2: Decimal.new(param2)]
  rescue
    error in Decimal.Error ->
      {:error, "Launch parameters configuration error: #{Exception.message(error)}"}
  end
end
