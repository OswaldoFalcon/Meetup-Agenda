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
    <table>
      {#for day <- Schedule.days_in_month(@today)}
        {#for meetings <- Schedule.day_meetings(day)}
          <tr>
            <td>{Timex.month_shortname(meetings.date.month)}, {meetings.date.day}
            </td>
            <td>{meetings.title}
            </td>
            <td>{meetings.description}
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
