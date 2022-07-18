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
        title: "some title",
        week: :second,
        year: :"2022"
      })
      |> Agenda.Schedule.create_meeting()

    meeting
  end
end
