defmodule AgendaWeb.Calendar do
  use Surface.LiveView
  use Timex
  alias AgendaWeb.Components.{CalendarTable, AgendaView}
  @today_date Timex.today()
  data today, :date, default: Timex.today()
  data month, :string, default: @today_date.month |> Timex.month_name()
  data year, :integer, default: @today_date.year
  data name_days, :list, default: [7, 1, 2, 3, 4, 5, 6] |> Enum.map(&Timex.day_shortname/1)

  def render(assigns) do
    ~F"""
  
    <div class="navigation">
      <div>
        {@month} {@year}
      </div>
      <button :on-click="change_month" phx-value-direction="previous">
        ←
      </button>
      <button :on-click="change_month" phx-value-direction="next">
        →
      </button>
    </div>

    <div>
    </div>
    <CalendarTable today={@today} month={@month} year={@year} name_days={@name_days} />
    <AgendaView today={@today} month={@month} year={@year} name_days={@name_days} />
    """
  end

  def handle_event("change_month", %{"direction" => direction}, socket) do
    case direction do
      "next" ->
        new_today = Timex.shift(socket.assigns.today, months: 1)

        {:noreply,
         assign(
           socket,
           today: new_today,
           month: Timex.month_name(new_today.month),
           year: new_today.year
         )}

      "previous" ->
        new_today = Timex.shift(socket.assigns.today, months: -1)

        {:noreply,
         assign(
           socket,
           today: new_today,
           month: Timex.month_name(new_today.month),
           year: new_today.year
         )}
    end
  end
end