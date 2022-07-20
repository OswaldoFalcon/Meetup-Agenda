defmodule AgendaWeb.CalendarTest do
  import Plug.Conn
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  @endpoint MyEndpoint
  use AgendaWeb.ConnCase

  defp create_socket(_) do
    %{socket: %Phoenix.LiveView.Socket{}}
  end

  describe "Socket State" do
    test "Change month forward", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/calendar")

      assert view
             |> element("#previous")
             |> has_element?()
    end
  end
end
