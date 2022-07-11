defmodule AgendaWeb.Components.CalendarTable do
  @moduledoc """
  A sample component to generate the form.
  """
  use Surface.Component
  alias Agenda.Schedule

  prop today, :date
  prop month, :date
  prop year, :date
  prop name_days, :list

  def render(assigns) do
    ~F"""
    <table>
      <tr>
        {#for name <- @name_days}
          <th>
            {name}
          </th>
        {#else}
          No items
        {/for}
      </tr>

      {#for week <- Schedule.week_rows(@today)}
        <tr>
          {#for day <- week}
            <td>
              {day.day} <br>
              {#for meetings <- Schedule.day_meetings(day)}
                🔵{meetings.title}
              {#else}
              {/for}
            </td>
          {#else}
            No items
          {/for}
        </tr>
      {#else}
        No items
      {/for}
    </table>
    """
  end
end
