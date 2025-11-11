defmodule Nasa.Domain.Util do
  @moduledoc """
  Utils helpers
  """
  @doc """
  Checks if input params coud be Decimal number.  

  ## Parameteres

      * `param1` - first calculation constant
      * `param2` - second calculation constant

  ## Examples

      iex> Nasa.Domain.Util(param1: "0.042", param2: Decimal.new("33"))
      [param1: Decimal.new("0.042), param2: Decimal.new("33)]
  """
  @spec check_params(param1: binary(), param2: binary()) ::
          [param1: Decimal.t(), param2: Decimal.t()] | {:error, binary()}
  def check_params([param1, param2]) do
    [param1: Decimal.new(param1), param2: Decimal.new(param2)]
  rescue
    error in Decimal.Error ->
      {:error, "Calculation parameters configuration error: #{Exception.message(error)}"}
  end
end
