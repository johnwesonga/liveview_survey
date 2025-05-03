defmodule Survey.Repo.Migrations.CreateChoices do
  use Ecto.Migration

  def change do
    create table(:choices) do
      add :choice_text, :string
      add :position, :integer
      add :question_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
