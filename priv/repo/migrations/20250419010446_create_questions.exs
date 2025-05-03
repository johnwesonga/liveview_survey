defmodule Survey.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :question_text, :text
      add :poll_id, references(:polls)
      add :question_type_id, references(:question_types)
      add :position, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
