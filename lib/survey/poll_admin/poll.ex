defmodule Survey.PollAdmin.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "polls" do
    field :title, :string
    field :description, :string
    field :status, Ecto.Enum, values: [:draft, :active, :closed]
    has_many :questions, Survey.PollAdmin.Question, on_replace: :delete, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:title, :description, :status])
    |> validate_required([:title, :description, :status])
    |> validate_length(:title, min: 1, max: 100)
    |> validate_length(:description, min: 1, max: 500)
    |> unique_constraint(:title, name: :polls_title_index)
    |> cast_assoc(:questions,
      with: &Survey.PollAdmin.Question.changeset/2,
      sort_param: :questions_sort,
      drop_param: :questions_drop,
      required: true
    )
  end
end
