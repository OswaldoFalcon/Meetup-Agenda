defmodule AgendaWeb.Components.DialogMeeting do
  @moduledoc """
  A sample component to generate the form.
  """
  use Surface.LiveComponent
  alias Agenda.Schedule.Meeting
  alias  Agenda.Schedule
  prop title, :string, required: true
  prop ok_label, :string, default: "Ok"
  prop close_label, :string, default: "Close"
  prop ok_click, :event, default: "close"
  prop close_click, :event, default: "close"
  prop id_db, :integer

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
        </section>
        <footer class="modal-card-foot" style="justify-content: flex-end">
          <button class="button is-danger is-outlined" :on-click="delete" :values={id: @id_db}>
            <span>Delete</span>
            <span class="icon is-small">
              <i class="fas fa-times" />
            </span>
          </button>
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

   def handle_event("delete", values, socket) do
    id = String.to_integer(values["id"]) 
    meeting = Schedule.get_meeting!(id)
    relative_today = Timex.today |> Timex.shift(days: 1)
    Schedule.delete_meeting(meeting)
    
    send(self(), {:today, relative_today})
    {:noreply, push_redirect(socket, to: "/calendar")}
   end

end
