defmodule Agenda.Schedule.Meeting do
  @moduledoc """
  This module build the Schema for Ecto
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "meetings" do
    field :day, Ecto.Enum,
      values: [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]

    field :description, :string

    field :month, Ecto.Enum,
      values: [
        :january,
        :february,
        :march,
        :april,
        :may,
        :june,
        :july,
        :august,
        :september,
        :october,
        :november,
        :december
      ]

    field :title, :string
    field :week, Ecto.Enum, values: [:first, :second, :third, :fourth, :fifth]
    field :year, Ecto.Enum, values: [:"2022", :"2023", :"2024", :"2025", :"2026"]

    timestamps()
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [:week, :day, :month, :year, :title, :description])
    |> validate_required([:week, :day, :month, :year, :description, :title])
  end
end
