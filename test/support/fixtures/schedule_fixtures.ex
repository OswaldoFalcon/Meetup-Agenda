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
        day: "some day",
        description: "some description",
        month: "some month",
        title: "some title",
        week: "some week",
        year: 42
      })
      |> Agenda.Schedule.create_meeting()

    meeting
  end
end
