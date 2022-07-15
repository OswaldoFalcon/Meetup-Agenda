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
              <DayCellTable month={@month} date={date} id={date} />
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
end
