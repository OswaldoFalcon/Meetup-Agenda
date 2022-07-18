defmodule Agenda.Schedule do
  @moduledoc """
  The Schedule context.
  """

  import Ecto.Query, warn: false
  alias Agenda.Repo
  alias Agenda.Dates
  alias Agenda.Schedule.Meeting

  @doc """
  Returns the list of meetings.

  ## Examples

      iex> list_meetings()
      [%Meeting{}, ...]

  """
  def list_meetings do
    Repo.all(Meeting)
  end

  @doc """
  Gets a single meeting.

  Raises `Ecto.NoResultsError` if the Meeting does not exist.

  ## Examples

      iex> get_meeting!(123)
      %Meeting{}

      iex> get_meeting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_meeting!(id), do: Repo.get!(Meeting, id)

  @doc """
  Creates a meeting.

  ## Examples

      iex> create_meeting(%{field: value})
      {:ok, %Meeting{}}

      iex> create_meeting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_meeting(attrs \\ %{}) do
    %Meeting{}
    |> Meeting.changeset(attrs)
    |> Repo.insert()
  end

  def insert_meeting(change) do
    Repo.insert(change)
  end

  @doc """
  Updates a meeting.

  ## Examples

      iex> update_meeting(meeting, %{field: new_value})
      {:ok, %Meeting{}}

      iex> update_meeting(meeting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meeting(%Meeting{} = meeting, attrs) do
    meeting
    |> Meeting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a meeting.

  ## Examples

      iex> delete_meeting(meeting)
      {:ok, %Meeting{}}

      iex> delete_meeting(meeting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meeting(%Meeting{} = meeting) do
    Repo.delete(meeting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meeting changes.

  ## Examples

      iex> change_meeting(meeting)
      %Ecto.Changeset{data: %Meeting{}}

  """
  def change_meeting(%Meeting{} = meeting, attrs \\ %{}) do
    Meeting.changeset(meeting, attrs)
  end

  # rows for calendar
  def week_rows(today) do
    from_date =
      today
      |> Timex.beginning_of_month()
      |> Timex.beginning_of_week(:sun)

    to_date =
      today
      |> Timex.end_of_month()
      |> Timex.end_of_week(:sun)

    Date.range(from_date, to_date, 1)
    |> Enum.take(42)
    |> Enum.chunk_every(7)
  end

  # days for Agenda view
  def days_in_month(date) do
    Date.range(Timex.beginning_of_month(date), Timex.end_of_month(date), 1)
    |> Enum.take(31)
  end

  def get_dates() do
    meets = Repo.all(Meeting)

    Enum.map(meets, fn meet ->
      Map.put(
        %{},
        :date,
        Dates.merge_date(meet.year, meet.month, meet.day, meet.week)
      )
      |> Map.put(:title, meet.title)
      |> Map.put(:description, meet.description)
      |> Map.put(:id, meet.id)
    end)
  end

  def day_meetings(date) do
    meetings = get_dates()
    Enum.filter(meetings, fn meet -> meet.date == date end)
  end

  def validate_date(year, month, weekday, range) do
    case Dates.merge_date(year, month, weekday, range) do
      :error_date_dont_exist -> false
      _ -> true
    end
  end
end
