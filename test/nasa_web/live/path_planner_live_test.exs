defmodule NasaWeb.PathPlannerLiveTest do
  use NasaWeb.ConnCase

  import Phoenix.LiveViewTest

  test "displays Launch - Earth string after submitting form with mass 28801, launch action, and earth planet",
       %{
         conn: conn
       } do
    {:ok, view, _html} = live(conn, ~p"/path")

    assert view
           |> form("#path-form", %{
             path: %{
               mass: "28801",
               spaceship_action: "launch",
               planet: "earth"
             }
           })
           |> render_submit()

    html = render(view)
    # Check for "Launch - Earth" (case-insensitive match)
    assert html =~ ~r/Launch - Earth/i
  end
end
