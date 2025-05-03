defmodule Survey.Repo.Migrations.CreateQuestionTypes do
  use Ecto.Migration

  def change do
    create table(:question_types) do
      add :question_type, :string

      timestamps(type: :utc_datetime)
    end
  end
end
