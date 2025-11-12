defmodule NasaWeb.PathPlannerLive do
  use NasaWeb, :live_view

  alias Nasa.Context.Path
  alias Nasa.Domain.PathFuel

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_path()
     |> assign_path_list([])
     |> assign_fuel(Decimal.new("0"))
     |> clear_form()}
  end

  def assign_path(socket) do
    socket
    |> assign(:path, %Path{})
  end

  def assign_path_list(socket, value) do
    socket
    |> assign(:path_list, value)
  end

  def assign_fuel(socket, value) do
    socket
    |> assign(:fuel, value)
  end

  def clear_form(socket) do
    changeset =
      socket.assigns.path
      |> Path.changeset(%{})

    socket |> assign_form(changeset)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def handle_event(
        "validate",
        %{"path" => path_params},
        %{assigns: %{path: path}} = socket
      ) do
    changeset =
      path
      |> Path.changeset(path_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event(
        "clear",
        _params,
        socket
      ) do
    {:noreply,
     socket
     |> assign_path()
     |> assign_path_list([])
     |> assign_fuel(Decimal.new("0"))
     |> clear_form()}
  end

  def handle_event(
        "save",
        %{"path" => %{"mass" => mass, "planet" => planet, "spaceship_action" => action}},
        socket
      ) do
    path_fuel = PathFuel.fuel(mass: mass, planet: planet, action: action)

    path =
      [
        %{action: action, planet: planet, mass: Decimal.new(mass), fuel: path_fuel}
        | socket.assigns.path_list
      ]

    {:noreply, socket |> assign_path_list(path)}
  end

  def handle_event(
        "calculate",
        _params,
        socket
      ) do
      path_list = PathFuel.recalculate_fuel(paths: Enum.reverse(socket.assigns.path_list))

    total_fuel =
      path_list
      |> Enum.reduce(Decimal.new("0"), fn %{
                                            action: _action,
                                            planet: _planet,
                                            mass: _mass,
                                            fuel: fuel
                                          },
                                          acc ->
        Decimal.add(acc, fuel)
      end)

    {:noreply, socket |> assign_path_list(path_list) |> assign_fuel(total_fuel)}
  end

  defp path_as_string(%{action: action, planet: planet, mass: mass, fuel: fuel}),
    do:
      "#{String.upcase(action)} - #{String.upcase(planet)} mass: #{Decimal.to_string(mass)} kg, fuel: #{Decimal.to_string(fuel)} kg"
end
