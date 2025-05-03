defmodule Survey.PollAdmin.QuestionType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question_types" do
    field :question_type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question_type, attrs) do
    question_type
    |> cast(attrs, [:question_type])
    |> validate_required([:question_type])
  end
end
