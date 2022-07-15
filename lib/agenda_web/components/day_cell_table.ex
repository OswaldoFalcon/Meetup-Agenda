defmodule AgendaWeb.Components.DayCellTable do
  @moduledoc """
  A sample component to generate the form.
  """
  use Surface.LiveComponent
  alias Agenda.Schedule
  alias AgendaWeb.Components.{DialogMeeting}

  prop date, :date
  prop month, :date

  def render(assigns) do
    ~F"""
    {#if @date.month == Timex.month_to_num(@month)}
      <td class="month-day">
        <div class="meeting-day-container">
          <strong>
            {@date.day}
          </strong>
        </div>
        {#for meetings <- Schedule.day_meetings(@date)}
          <DialogMeeting
            title={"#{@date.day} #{@month} #{meetings.title}"}
            id={"#{@date.day}-#{meetings.title}"}
            id_db={meetings.id}
          >
            <div>
              <strong>Description:
              </strong>
              {meetings.description}
            </div>
            <br>
          </DialogMeeting>
          <div class="meeting-title-container">
            <span :on-click="open_dialog" :values={id: @date.day, title: meetings.title}>
              <span class="circle"><i class="fi fi-ss-circle-small" />
              </span>
              {meetings.title}
            </span>
          </div>
        {#else}
        {/for}
      </td>
    {#else}
      <td class="other-month-day">
        <div class="meeting-day-container">
          <strong>
            {@date.day}
          </strong>
        </div>
        {#for meetings <- Schedule.day_meetings(@date)}
          <div class="meeting-title-container">
            <span class="circle"><i class="fi fi-ss-circle-small" />
            </span>
            {meetings.title}
          </div>
        {#else}
        {/for}
      </td>
    {/if}
    """
  end

  def handle_event("open_dialog", values, socket) do
    id = "#{values["id"]}-#{values["title"]}"
    DialogMeeting.open(id)
    {:noreply, socket}
  end
end
