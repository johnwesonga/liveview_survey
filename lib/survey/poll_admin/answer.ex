defmodule Survey.PollAdmin.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field :free_text, :string
    belongs_to :choice, Survey.PollAdmin.Choice
    belongs_to :question, Survey.PollAdmin.Question
    belongs_to :response, Survey.PollAdmin.Response

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:free_text, :choice_id, :question_id])
    |> validate_choice_or_text()
    |> validate_required([:question_id])
    |> foreign_key_constraint(:question_id)
  end

  # Custom validation: either choice or free_text must be present
  defp validate_choice_or_text(changeset) do
    choice_id = get_field(changeset, :choice_id)
    free_text = get_field(changeset, :free_text)

    if is_nil(choice_id) && is_nil(free_text) do
      add_error(changeset, :base, "Either choice_id or free_text must be present")
    else
      changeset
    end
  end
end
