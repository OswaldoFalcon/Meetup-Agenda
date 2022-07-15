defmodule AgendaWeb.Calendar do
  use Surface.LiveView
  use Timex
  alias AgendaWeb.Components.{CalendarTable, AgendaView, DialogConfig, FormDialog}
  @today_date Timex.today()
  data today, :date, default: Timex.today()
  data month, :string, default: @today_date.month |> Timex.month_name()
  data year, :integer, default: @today_date.year
  data name_days, :list, default: [7, 1, 2, 3, 4, 5, 6] |> Enum.map(&Timex.day_shortname/1)
  data agenda, :boolean, default: true
  data calendar, :boolean, default: true

  def render(assigns) do
    ~F"""
    <div class="content">
      <div class="navigation">
        <div>
          <p>{@month} {@year}</p>
        </div>
        <div class="arrows">
          <button class="button is-info is-hovered" :on-click="change_month" phx-value-direction="previous">
            ←
          </button>
          <button class="button is-info is-hovered" :on-click="change_month" phx-value-direction="next">
            →
          </button>
        </div>
        <div>
          <button class="button is-info is-hovered" :on-click="add_meeting">
            <i class="fi fi-br-calendar-plus" />
          </button>
          <button class="button is-info is-hovered" :on-click="open_config">
            <i class="fi fi-ss-settings" />
          </button>
        </div>
      </div>

      {#if @calendar == true}
        <div class="calendar">
          <CalendarTable today={@today} month={@month} year={@year} name_days={@name_days} />
        </div>
      {#else}
      {/if}
      {#if @agenda == true}
      <div class="agenda">
        <AgendaView today={@today} month={@month} year={@year} name_days={@name_days} />
      </div>
      {#else}
      {/if}
      <DialogConfig id="dailog_config" title="Configuration View" agenda={@agenda} calendar={@calendar}> </DialogConfig>

      <FormDialog title="Add a Meeting to your Agenda" id="form_dialog" />
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

  def handle_event("open_config", _, socket) do
    DialogConfig.open("dailog_config")
    {:noreply, socket}
  end

  def handle_event("add_meeting", _, socket) do
    FormDialog.open("form_dialog")
    {:noreply, socket}
  end

  def handle_info({:agenda, agenda_state}, socket) do
    {:noreply,
     assign(socket,
       agenda: agenda_state
     )}
  end

  def handle_info({:calendar, calendar_state}, socket) do
    {:noreply,
     assign(socket,
       calendar: calendar_state
     )}
  end
end
