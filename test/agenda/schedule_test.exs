defmodule Agenda.ScheduleTest do
  use Agenda.DataCase

  alias Agenda.{Schedule, Dates}

  describe "meetings" do
    alias Agenda.Schedule.Meeting

    import Agenda.ScheduleFixtures

    @invalid_attrs %{day: nil, description: nil, month: nil, title: nil, week: nil, year: nil}

    test "list_meetings/0 returns all meetings" do
      meeting = meeting_fixture()
      assert Schedule.list_meetings() == [meeting]
    end

    test "get_meeting!/1 returns the meeting with given id" do
      meeting = meeting_fixture()
      assert Schedule.get_meeting!(meeting.id) == meeting
    end

    test "create_meeting/1 with valid data creates a meeting" do
      valid_attrs = %{
        day: :tuesday,
        description: "some description",
        month: :july,
        title: "title",
        week: :second,
        year: :"2022"
      }

      assert {:ok, %Meeting{} = meeting} = Schedule.create_meeting(valid_attrs)
      assert meeting.day == :tuesday
      assert meeting.description == "some description"
      assert meeting.month == :july
      assert meeting.title == "title"
      assert meeting.week == :second
      assert meeting.year == :"2022"
    end

    test "create_meeting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedule.create_meeting(@invalid_attrs)
    end

    test "update_meeting/2 with valid data updates the meeting" do
      meeting = meeting_fixture()

      update_attrs = %{
        day: :tuesday,
        description: "some updated description",
        month: :july,
        title: "some updated title",
        week: :second,
        year: :"2022"
      }

      assert {:ok, %Meeting{} = meeting} = Schedule.update_meeting(meeting, update_attrs)
      assert meeting.day == :tuesday
      assert meeting.description == "some updated description"
      assert meeting.month == :july
      assert meeting.title == "some updated title"
      assert meeting.week == :second
      assert meeting.year == :"2022"
    end

    test "update_meeting/2 with invalid data returns error changeset" do
      meeting = meeting_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedule.update_meeting(meeting, @invalid_attrs)
      assert meeting == Schedule.get_meeting!(meeting.id)
    end

    test "delete_meeting/1 deletes the meeting" do
      meeting = meeting_fixture()
      assert {:ok, %Meeting{}} = Schedule.delete_meeting(meeting)
      assert_raise Ecto.NoResultsError, fn -> Schedule.get_meeting!(meeting.id) end
    end

    test "change_meeting/1 returns a meeting changeset" do
      meeting = meeting_fixture()
      assert %Ecto.Changeset{} = Schedule.change_meeting(meeting)
    end

    test "rows for the calendar" do
      rows = Schedule.week_rows(~D[2022-07-18])
      assert Schedule.week_rows(~D[2022-07-01]) == rows
      assert Schedule.week_rows(~D[2022-07-31]) == rows
      assert Schedule.week_rows(~D[2022-08-31]) == rows == false
    end

    test "Merge dates with valid data" do
      params = %{
        day: :tuesday,
        month: :july,
        week: :second,
        year: :"2022"
      }

      assert Dates.merge_date(params.year, params.month, params.day, params.week) ==
               ~D[2022-07-12]
    end

    test "Merge dates with invalid data" do
      params = %{
        day: :monday,
        month: :july,
        week: :fifth,
        year: :"2022"
      }

      assert Dates.merge_date(params.year, params.month, params.day, params.week) ==
               :error_date_dont_exist
    end

    test "Days in the month" do
      days = Schedule.days_in_month(~D[2022-07-18])
      assert length(days) == 31
      days = Schedule.days_in_month(~D[2022-08-18])
      assert length(days) == 31
      days = Schedule.days_in_month(~D[2022-09-18])
      assert length(days) == 30
    end

    test "Get meetings dates info" do
      meet = meeting_fixture()

      params = %{
        date: ~D[2022-07-12],
        description: "some description",
        id: meet.id,
        title: "title"
      }

      assert [params] == Schedule.get_dates()
    end

    test "day that fits with a meeting" do
      meet = meeting_fixture()

      params = %{
        date: ~D[2022-07-12],
        description: "some description",
        id: meet.id,
        title: "title"
      }

      assert Schedule.day_meetings(~D[2022-07-12]) == [params]
    end

    test "validate date with valid data" do
      params = %{
        day: :monday,
        month: :july,
        week: :first,
        year: :"2022"
      }

      assert Schedule.validate_date(params.year, params.month, params.day, params.week) == true

      params = %{
        day: :monday,
        month: :july,
        week: :third,
        year: :"2022"
      }

      assert Schedule.validate_date(params.year, params.month, params.day, params.week) == true

      params = %{
        day: :monday,
        month: :july,
        week: :fourth,
        year: :"2022"
      }

      assert Schedule.validate_date(params.year, params.month, params.day, params.week) == true
    end

    test "validate date with invalid data" do
      params = %{
        day: :monday,
        month: :july,
        week: :fifth,
        year: :"2022"
      }

      assert Schedule.validate_date(params.year, params.month, params.day, params.week) == false
    end
  end
end
