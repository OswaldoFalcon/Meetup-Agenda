defmodule AgendaWeb.Components.DialogMeeting do
   @moduledoc """
  A sample component to generate the form.
  """
  use Surface.LiveComponent

  prop title, :string, required: true
  prop ok_label, :string, default: "Ok"
  prop close_label, :string, default: "Close"
  prop ok_click, :event, default: "close"
  prop close_click, :event, default: "close"

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
          <button :on-click={@ok_click}> {@ok_label} </button>
          <button :on-click={@close_click} kind="is-danger">> {@close_label} </button>
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
end