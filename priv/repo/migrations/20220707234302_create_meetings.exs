defmodule Agenda.Repo.Migrations.CreateMeetings do
  use Ecto.Migration

  def change do
    create table(:meetings) do
      add :week, :string
      add :day, :string
      add :month, :string
      add :year, :string
      add :title, :string
      add :description, :string

      timestamps()
    end
  end
end
