defmodule AgendaWeb.Components.CalendarTable do
  @moduledoc """
  A sample component to generate the form.
  """
  use Surface.LiveComponent
  alias Agenda.Schedule
  alias AgendaWeb.Components.{DialogMeeting}

  prop today, :date
  prop month, :date
  prop year, :date
  prop name_days, :list

  def render(assigns) do
    ~F"""
    <table>
      <thead>
        <tr>
          {#for name <- @name_days}
            <th>
              <div class="th-title">
                {name}
              </div>
            </th>
          {#else}
            No items
          {/for}
        </tr>
      </thead>
      <tbody>
        {#for week <- Schedule.week_rows(@today)}
          <tr>
            {#for date <- week}
              {#if date.month == Timex.month_to_num(@month)}
                <td class="month-day">
                  <div class="meeting-day-container">
                    <strong>
                      {date.day}
                    </strong>
                  </div>
                  {#for meetings <- Schedule.day_meetings(date)}
                    <DialogMeeting
                      title={" #{@month} #{date.day} -  #{meetings.title}"}
                      id={"#{date.day}-#{meetings.title}"}
                      id_db={meetings.id}
                    >
                      <div>
                        <strong>Description:
                        </strong>
                        {meetings.description}
                      </div>
                      <br>
                    </DialogMeeting>
                    <div>
                      <span
                        class="meeting-title-container"
                        :on-click="open_dialog"
                        :values={id: date.day, title: meetings.title}
                        id={"meet-#{date.day}-#{meetings.title}"}
                      >
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
                      {date.day}
                    </strong>
                  </div>
                  {#for meetings <- Schedule.day_meetings(date)}
                    <div>
                      <span class="circle"><i class="fi fi-ss-circle-small" />
                      </span>
                      {meetings.title}
                    </div>
                  {#else}
                  {/for}
                </td>
              {/if}
            {#else}
              No items
            {/for}
          </tr>
        {#else}
          No items
        {/for}
      </tbody>
    </table>
    """
  end

  def handle_event("open_dialog", values, socket) do
    id = "#{values["id"]}-#{values["title"]}"
    DialogMeeting.open(id)
    {:noreply, socket}
  end
end
