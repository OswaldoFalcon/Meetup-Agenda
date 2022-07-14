defmodule AgendaWeb.Components.DialogConfig do
  @moduledoc """
  A sample component to generate the form.
  """
  use Surface.LiveComponent
  alias Surface.Components.Form.Checkbox

  prop title, :string, required: true
  prop ok_label, :string, default: "Ok"
  prop close_label, :string, default: "Close"
  prop ok_click, :event, default: "close"
  prop close_click, :event, default: "close"
  prop agenda, :boolean
  prop calendar, :boolean

  data show, :boolean, default: false

  slot default

  def render(assigns) do
    ~F"""
    <div class={"modal", "is-active": @show} :on-window-keydown={@close_click} phx-key="Escape">
      <div class="modal-background" />
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">{@title}</p>
        </header>
        <section class="modal-card-body">
          <#slot />
          General view
          <fieldset>
            {#if @agenda == true}
              <Checkbox field="Agenda View" click="agenda_switch" value="true" /> Agenda View <br>
            {#else}
              <Checkbox field="Agenda View" click="agenda_switch" value="false" /> Agenda View <br>
            {/if}
            {#if @calendar == true}
              <Checkbox field="Calendar View" click="calendar_switch" value="true" /> Calendar View <br>
            {#else}
              <Checkbox field="Calendar View" click="calendar_switch" value="false" /> Calendar View <br>
            {/if}
          </fieldset>
        </section>
        <footer class="modal-card-foot" style="justify-content: flex-end">
          <button :on-click={@close_click} class="button is-danger">
            {@close_label}
          </button>
        </footer>
      </div>
    </div>
    """
  end

  # Public API

  def open(dialog_id) do
    send_update(__MODULE__, id: dialog_id, show: true)
  end

  def close(dialog_id) do
    send_update(__MODULE__, id: dialog_id, show: false)
  end

  # Default event handlers

  def handle_event("close", _, socket) do
    {:noreply, assign(socket, show: false)}
  end

  def handle_event("agenda_switch", _, socket) do
    agenda_state = change_state(socket.assigns.agenda)
    send(self(), {:agenda, agenda_state})
    {:noreply, assign(socket, agenda: agenda_state)}
  end

  def handle_event("calendar_switch", _, socket) do
    calendar_state = change_state(socket.assigns.calendar)
    send(self(), {:calendar, calendar_state})
    {:noreply, assign(socket, calendar: calendar_state)}
  end

  defp change_state(view) do
    cond do
      view == true -> false
      view == false -> true
    end
  end
end
