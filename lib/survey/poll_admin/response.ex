defmodule Survey.PollAdmin.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    belongs_to :poll, Survey.PollAdmin.Poll
    has_many :answers, Survey.PollAdmin.Answer, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:poll_id])
    |> validate_required([:poll_id])
    |> foreign_key_constraint(:poll_id)
    |> cast_assoc(:answers,
      with: &Survey.PollAdmin.Answer.changeset/2,
      sort_param: :answers_sort,
      drop_param: :answers_drop,
      required: true
    )
  end
end
