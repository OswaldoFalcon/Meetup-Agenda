defmodule AgendaWeb.MeetingController do
  use AgendaWeb, :controller

  alias Agenda.Schedule
  alias Agenda.Schedule.Meeting

  def index(conn, _params) do
    meetings = Schedule.list_meetings()
    render(conn, "index.html", meetings: meetings)
  end

  def new(conn, _params) do
    changeset = Schedule.change_meeting(%Meeting{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"meeting" => meeting_params}) do
    case Schedule.create_meeting(meeting_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Meeting created successfully.")
        |> redirect(to: "/calendar")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:info, "Meeting created successfully.")
        |> redirect(to: "/calendar")
        
    end
  end

  def show(conn, %{"id" => id}) do
    meeting = Schedule.get_meeting!(id)
    render(conn, "show.html", meeting: meeting)
  end

  def edit(conn, %{"id" => id}) do
    meeting = Schedule.get_meeting!(id)
    changeset = Schedule.change_meeting(meeting)
    render(conn, "edit.html", meeting: meeting, changeset: changeset)
  end

  def update(conn, %{"id" => id, "meeting" => meeting_params}) do
    meeting = Schedule.get_meeting!(id)

    case Schedule.update_meeting(meeting, meeting_params) do
      {:ok, meeting} ->
        conn
        |> put_flash(:info, "Meeting updated successfully.")
        |> redirect(to: Routes.meeting_path(conn, :show, meeting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", meeting: meeting, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    meeting = Schedule.get_meeting!(id)
    {:ok, _meeting} = Schedule.delete_meeting(meeting)

    conn
    |> put_flash(:info, "Meeting deleted successfully.")
    |> redirect(to: Routes.meeting_path(conn, :index))
  end
end
