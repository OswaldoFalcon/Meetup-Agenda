defmodule AgendaWeb.Calendar do
  use Surface.LiveView
  use Timex
  alias AgendaWeb.Components.{CalendarTable, AgendaView, DialogMeeting}
  @today_date Timex.today()
  data today, :date, default: Timex.today()
  data month, :string, default: @today_date.month |> Timex.month_name()
  data year, :integer, default: @today_date.year
  data name_days, :list, default: [7, 1, 2, 3, 4, 5, 6] |> Enum.map(&Timex.day_shortname/1)

  def render(assigns) do
    ~F"""
    <div class="content"> 
    <div class="navigation">
      <div>
        <p>{@month} {@year}</p>
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
    </div>
    <div>
    <DialogMeeting  title="Meeting Dialog" id="as">
    Clicking <strong>"Ok"</strong> or <strong>"Close"</strong>
    closes the form (default behaviour).
    <button :on-click="open_dialog" > a</button>
  </DialogMeeting>
    </div>
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

  def handle_event("open_dialog",_, socket) do
    IO.puts("as")
    DialogMeeting.open("as")
    {:noreply, socket}
  end
end
