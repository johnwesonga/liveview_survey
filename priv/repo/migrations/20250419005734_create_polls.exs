defmodule Survey.Repo.Migrations.CreatePolls do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :title, :string
      add :description, :text
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
