defmodule Survey.PollAdmin.Choice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "choices" do
    field :choice_text, :string
    field :position, :integer, default: 1
    # Associations
    belongs_to :question, Survey.PollAdmin.Question, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(choice, attrs) do
    choice
    |> cast(attrs, [:choice_text, :position])
    |> validate_required([:choice_text])
    |> foreign_key_constraint(:question_id)
  end
end
