defmodule Survey.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :poll_id, references(:polls)

      timestamps(type: :utc_datetime)
    end
  end
end
