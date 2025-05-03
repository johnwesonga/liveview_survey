defmodule Survey.PollAdmin.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :question_text, :string
    field :position, :integer, default: 1
    # Associations
    belongs_to :poll, Survey.PollAdmin.Poll, on_replace: :delete
    belongs_to :question_type, Survey.PollAdmin.QuestionType, on_replace: :delete
    has_many :choices, Survey.PollAdmin.Choice, on_replace: :delete, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:question_text, :position, :question_type_id])
    |> validate_required([:question_text])
    # |> foreign_key_constraint(:poll_id)
    # |> foreign_key_constraint(:question_type_id)
    # |> cast_assoc(:poll)
    |> cast_assoc(:question_type)
    |> cast_assoc(:choices,
      with: &Survey.PollAdmin.Choice.changeset/2,
      sort_param: :choices_sort,
      drop_param: :choices_drop
    )
  end
end
