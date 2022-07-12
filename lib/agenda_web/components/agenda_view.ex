defmodule AgendaWeb.Components.AgendaView do
  @moduledoc """
  A sample component to generate the form.
  """
  use Surface.Component
  use Timex
  alias Agenda.Schedule

  prop today, :date
  prop month, :date
  prop year, :date
  prop name_days, :list

  def render(assigns) do
    ~F"""
    <p> Agenda view </p>
    <table>
      {#for day <- Schedule.days_in_month(@today)}
        {#for meetings <- Schedule.day_meetings(day)}
          <tr>
            <td class="agenda">
              <p> {meetings.date.day} </p>
              {Timex.month_shortname(meetings.date.month)}, {Timex.weekday(day)|> Timex.day_shortname}
            </td>
            <td class="agenda">{meetings.title}
            </td>
            <td class="agenda">{meetings.description}
            </td>
          </tr>
        {#else}
        {/for}
      {#else}
      {/for}
    </table>
    """
  end
end
