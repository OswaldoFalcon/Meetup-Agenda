defmodule AgendaWeb.Components.DayCellTable do
  @moduledoc """
  A sample component to generate the form.
  """
  use Surface.LiveComponent
  alias Agenda.Schedule
  alias AgendaWeb.Components.{DialogMeeting}

  prop date, :date
  prop month, :date
  data message, :string, default: ""

  def render(assigns) do
    ~F"""
    <div>
      {#if @date.month == Timex.month_to_num(@month)}
        <td class="month-day">
          {@date.day} <br>
          {#for meetings <- Schedule.day_meetings(@date)}
            <DialogMeeting
              title={"#{@date.day} #{@month} #{meetings.title}"}
              id={@date.day}
              id_db={meetings.id}
            >
              <div>
                <strong>Description:
                </strong>
                {meetings.description}
              </div>
              <br>
            </DialogMeeting>

            <span :on-click="open_dialog" :values={id: @date.day}>
              🔵{meetings.title}
            </span>
            {@message}
          {#else}
          {/for}
        </td>
      {#else}
        <td class="other-month-day">
          {@date.day} <br>
          {#for meetings <- Schedule.day_meetings(@date)}
            🔵{meetings.title}
          {#else}
          {/for}
        </td>
      {/if}
    </div>
    """
  end

  def handle_event("open_dialog", values, socket) do
    id = values["id"] |> String.to_integer()
    DialogMeeting.open(id)
    {:noreply, socket}
  end
end

3
