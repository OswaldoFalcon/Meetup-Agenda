defmodule Agenda.ScheduleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Agenda.Schedule` context.
  """

  @doc """
  Generate a meeting.
  """
  def meeting_fixture(attrs \\ %{}) do
    {:ok, meeting} =
      attrs
      |> Enum.into(%{
        day: :tuesday,
        description: "some description",
        month: :july,
        title: "title",
        week: :second,
        year: :"2022"
      })
      |> Agenda.Schedule.create_meeting()

    meeting
  end

  def meeting_fixture_august(attrs \\ %{}) do
    {:ok, meeting} =
      attrs
      |> Enum.into(%{
        day: :tuesday,
        description: "some description",
        month: :august,
        title: "some title",
        week: :first,
        year: :"2022"
      })
      |> Agenda.Schedule.create_meeting()

    meeting
  end
end
