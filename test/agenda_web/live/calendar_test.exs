defmodule AgendaWeb.CalendarTest do
  import Plug.Conn
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  @endpoint MyEndpoint
  use AgendaWeb.ConnCase
  alias AgendaWeb.Components.{AgendaView, CalendarTable}
  use Surface.LiveViewTest

  #  use Agenda.DataCase
  import Agenda.ScheduleFixtures

  describe "Calendar UI" do
    test "Button change previous month", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/calendar")

      assert view
             |> element("#previous")
             |> render_click
    end

    test "Button change next month", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/calendar")

      assert view
             |> element("#next")
             |> render_click
    end

    test "Button open and delete meeting", %{conn: conn} do
      meeting_fixture()
      # open the Dialog Meeting
      {:ok, view, _html} = live(conn, "/calendar")

      assert view
             |> element("#meet-12-title")
             |> render_click

      # delete Meeti
      assert view
             |> element("#delete-meeting")
             |> render_click
    end

    test "Button close meeting", %{conn: conn} do
      meeting_fixture()
      # open the Dialog Meeting
      {:ok, view, _html} = live(conn, "/calendar")

      assert view
             |> element("#meet-12-title")
             |> render_click

      # delete Meeting
      assert view
             |> element("#close-meeting")
             |> render_click
    end

    test "Config Dialog", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/calendar")
      # open Dialog
      view
      |> element("#open_config")
      |> render_click

      # checkbox calendar
      view
      |> element("#calendar")
      |> render_click

      view
      |> element("#agenda")
      |> render_click

      view
      |> element("#calendar")
      |> render_click

      assert view
             |> element("#title")
             |> has_element?()

      # close agenda
      view
      |> element("#close_dialog")
      |> render_click

      assert view
             |> element("#title")
             |> has_element?()
    end

    test "AgendaView" do
      meeting_fixture()

      render_surface do
        ~F"""
        <AgendaView
          today={~D[2022-07-21]}
          month="july"
          year={2022}
          name_days={[7, 1, 2, 3, 4, 5, 6] |> Enum.map(&Timex.day_shortname/1)}
        />
        """
      end
    end

    test "Meeting Form Dialog", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/calendar")
      # open Meeting Form
      view
      |> element("#open_meeting_form")
      |> render_click

      # submit data not strict
      view
      |> form("form", %{
        data: %{}
      })
      |> render_submit

      # submit data  strict
      view
      |> element("#strict_mode")
      |> render_click

      view
      |> form("form", %{
        data: %{}
      })
      |> render_submit

      # quit strict mode
      view
      |> element("#strict_mode")
      |> render_click

      view
      |> element("#close_meeting_form")
      |> render_click
    end

    test "Calendar Table" do
      meeting_fixture()
      meeting_fixture_august()

      render_surface do
        ~F"""
        <CalendarTable
          today={~D[2022-07-21]}
          month="july"
          year={2022}
          name_days={[7, 1, 2, 3, 4, 5, 6] |> Enum.map(&Timex.day_shortname/1)}
          id="calendar"
        />
        """
      end
    end
  end
end
