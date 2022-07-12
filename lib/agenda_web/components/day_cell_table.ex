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
   

    {#if @date.month == Timex.month_to_num(@month)}
      <td class="month-day">
        {@date.day} <br>
        {#for meetings <- Schedule.day_meetings(@date)}
          <span>
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

    
    """
  end

 
end
