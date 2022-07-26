defmodule AgendaWeb.CalendarTest do
  import Plug.Conn
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  @endpoint MyEndpoint
  use AgendaWeb.ConnCase
  alias AgendaWeb.Components.{AgendaView, CalendarTable}
  alias Agenda.Schedule
  use Surface.LiveViewTest

  #  use Agenda.DataCase
  import Agenda.ScheduleFixtures

  describe "Calendar UI" do
    test "Button change previous month", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/calendar")
      month = Schedule.previous_month(Timex.today()) |> Map.get(:month) |> Timex.month_name()
      year = Schedule.previous_month(Timex.today()) |> Map.get(:year)

      assert view
             |> element("#previous")
             |> render_click =~ "<p>#{month} #{year}</p>"
    end

    test "Button change next month", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/calendar")
      month = Schedule.next_month(Timex.today()) |> Map.get(:month) |> Timex.month_name()
      year = Schedule.previous_month(Timex.today()) |> Map.get(:year)

      assert view
             |> element("#next")
             |> render_click =~ "<p>#{month} #{year}</p>"
    end

    test "Button Open Meeting Dialog", %{conn: conn} do
      meeting_fixture()
      {:ok, view, _html} = live(conn, "/calendar")

      assert view
             |> element("#meet-12-title")
             |> render_click =~ "<p class=\"modal-card-title\"> July 12 -  title</p>"
    end

    test "Button Delete a Meeting ", %{conn: conn} do
      meeting_fixture()
      id = Schedule.list_meetings() |> List.last() |> Map.get(:id)
      close = "#close" <> "#{id}"
      delete = "#delete" <> "#{id}"
      # open the Dialog Meeting
      {:ok, view, _html} = live(conn, "/calendar")

      view
      |> element("#meet-12-title")
      |> render_click

      # close Meeting
      view
      |> element(close)
      |> render_click

      # Reopen Meeting
      view
      |> element("#meet-12-title")
      |> render_click

      # delete Meeting
      view
      |> element(delete)
      |> render_click

      # check if meet exist ?
      {:ok, view, _html} = live(conn, "/calendar")
      element = view |> has_element?("#meet-12-title")
      assert false == element
    end

    test "Config Calendar View", %{conn: conn} do
      meeting_fixture()
      {:ok, view, _html} = live(conn, "/calendar")
      # open Dialog

      assert view
             |> element("#open_config")
             |> render_click

      # switching calendar
      assert view
             |> element("#calendar_off")
             |> render_click

      assert has_element?(view, "#calendar_table") == false

      view
      |> element("#agenda_off")
      |> render_click

      assert has_element?(view, "#agenda") == false

      # switching  agenda
      assert view
             |> element("#calendar_on")
             |> render_click

      assert has_element?(view, "#calendar_table")

      view
      |> element("#agenda_on")
      |> render_click

      assert has_element?(view, "#agenda")

      # close agenda
      view
      |> element("#close_dialog")
      |> render_click
    end

    test "AgendaView" do
      meeting_fixture()

      html =
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

      assert html =~ "<p>\n  Agenda view\n</p>"
    end

    test "Submit valid data strict-mode-off", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/calendar")
      # open Meeting Form
      view
      |> element("#open_meeting_form")
      |> render_click

      view
      |> form("form", %{
        meeting: %{
          title: "SomeTitle",
          description: "some description",
          week: "first",
          day: "monday",
          month: "july",
          year: "2022"
        }
      })
      |> render_submit

      assert has_element?(view, "#succes-BD")
    end

    test "Submit invalid data strict-mode-off", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/calendar")

      view
      |> form("form", %{
        meeting: %{
          title: "SomeTitle",
          description: "some description",
          week: "fifth",
          day: "monday",
          month: "july",
          year: "2022"
        }
      })
      |> render_submit

      assert has_element?(view, "#error-BD")
    end

    test "Submit day occupied on strict-mode", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/calendar")
      meeting_fixture()

      view
      |> element("#strict_mode")
      |> render_click

      # submit data
      view
      |> form("form", %{
        meeting: %{
          title: "SomeTitle",
          description: "some description",
          week: "second",
          day: "tuesday",
          month: "july",
          year: "2022"
        }
      })
      |> render_submit

      assert has_element?(view, "#error-BD")
    end

    test "Submit day not occupied strict-mode", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/calendar")

      view
      |> form("form", %{
        meeting: %{
          title: "SomeTitle",
          description: "some description",
          week: "second",
          day: "monday",
          month: "july",
          year: "2022"
        }
      })
      |> render_submit

      assert has_element?(view, "#succes-BD")
    end

    test "Submit invalid data strict-mode", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/calendar")

      view
      |> form("form", %{
        meeting: %{
          title: nil,
          description: nil,
          week: "fifth",
          day: "monday",
          month: "july",
          year: "2022"
        }
      })
      |> render_submit

      assert has_element?(view, "#error-BD")
      # quit strict mode
      view
      |> element("#strict_mode")
      |> render_click

      # close
      view
      |> element("#close_meeting_form")
      |> render_click
    end

    test "Calendar Table" do
      meeting_fixture_august()
      meeting_fixture()

      html =
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

      assert html =~ "<table>"
      assert html =~ "<p class=\"modal-card-title\"> july 12 -  title</p>"
    end
  end
end
