defmodule AgendaWeb.Components.CalendarTable do
  @moduledoc """
  A sample component to generate the form.
  """
  alias AgendaWeb.Components.{DayCellTable}
  use Surface.Component
  alias Agenda.Schedule

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
              {name}
            </th>
          {#else} 
            No items
          {/for}
        </tr>
      </thead>
      {#for week <- Schedule.week_rows(@today)}
        <tr>
          {#for date <- week}
           <DayCellTable month={@month} date={date} id={date} />
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
