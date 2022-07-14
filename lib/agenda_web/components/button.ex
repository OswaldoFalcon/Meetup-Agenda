defmodule AgendaWeb.Components.Button do
  use Surface.Component

  prop type, :string, default: "button"
  prop label, :string
  prop click, :event, required: true
  prop kind, :string, default: "info"
  prop size, :string, default: "normal"
  prop value, :any
  prop disabled, :boolean
  prop rounded, :boolean
  prop outlined, :boolean
  prop loading, :boolean

  slot default

  def render(assigns) do
    ~F"""
    <button
      type={@type}
      class={
        "button",
        "is-#{@size}",
        if(@outlined, do: "is-outlined"),
        if(@rounded, do: "is-rounded"),
        if(@disabled, do: "is-static", else: "is-#{@kind}"),
        if(@loading, do: "is-loading")
      }
      :on-click={@click}
      value={@value}
    >
      <#slot>{@label}</#slot>
    </button>
    """
  end
end
