defmodule Agenda.ScheduleTest do
  use Agenda.DataCase

  alias Agenda.Schedule

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
        day: "some day",
        description: "some description",
        month: "some month",
        title: "some title",
        week: "some week",
        year: 42
      }

      assert {:ok, %Meeting{} = meeting} = Schedule.create_meeting(valid_attrs)
      assert meeting.day == "some day"
      assert meeting.description == "some description"
      assert meeting.month == "some month"
      assert meeting.title == "some title"
      assert meeting.week == "some week"
      assert meeting.year == 42
    end

    test "create_meeting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedule.create_meeting(@invalid_attrs)
    end

    test "update_meeting/2 with valid data updates the meeting" do
      meeting = meeting_fixture()

      update_attrs = %{
        day: "some updated day",
        description: "some updated description",
        month: "some updated month",
        title: "some updated title",
        week: "some updated week",
        year: 43
      }

      assert {:ok, %Meeting{} = meeting} = Schedule.update_meeting(meeting, update_attrs)
      assert meeting.day == "some updated day"
      assert meeting.description == "some updated description"
      assert meeting.month == "some updated month"
      assert meeting.title == "some updated title"
      assert meeting.week == "some updated week"
      assert meeting.year == 43
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
  end
end
