defmodule Survey.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :free_text, :text
      add :choice_id, references(:choices, on_delete: :delete_all)
      add :question_id, references(:questions, on_delete: :delete_all)
      add :response_id, references(:responses, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
