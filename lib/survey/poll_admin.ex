defmodule Survey.PollAdmin do
  @moduledoc """
  The PollAdmin context.
  """

  import Ecto.Query, warn: false
  alias Survey.Repo

  alias Survey.PollAdmin.Poll

  @doc """
  Returns the list of polls.

  ## Examples

      iex> list_polls()
      [%Poll{}, ...]

  """
  def list_polls do
    Poll |> order_by(desc: :id) |> Repo.all()
  end

  @doc """
  Gets a single poll.

  Raises `Ecto.NoResultsError` if the Poll does not exist.

  ## Examples

      iex> get_poll!(123)
      %Poll{}

      iex> get_poll!(456)
      ** (Ecto.NoResultsError)

  """

  # def get_poll!(id), do: Repo.get!(Poll, id)

  def get_poll!(id) do
    Poll
    |> Repo.get!(id)
    |> Repo.preload(questions: [:choices, :question_type])
  end

  def get_poll_by_title!(title) do
    Repo.get_by(Poll, title: title)
  end

  @doc """
  Creates a poll.

  ## Examples

      iex> create_poll(%{field: value})
      {:ok, %Poll{}}

      iex> create_poll(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_poll(attrs) do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a poll.

  ## Examples

      iex> update_poll(poll, %{field: new_value})
      {:ok, %Poll{}}

      iex> update_poll(poll, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_poll(%Poll{} = poll, attrs) do
    poll
    |> Poll.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a poll.

  ## Examples

      iex> delete_poll(poll)
      {:ok, %Poll{}}

      iex> delete_poll(poll)
      {:error, %Ecto.Changeset{}}

  """
  def delete_poll(%Poll{} = poll) do
    Repo.delete(poll)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking poll changes.

  ## Examples

      iex> change_poll(poll)
      %Ecto.Changeset{data: %Poll{}}

  """
  def change_poll(%Poll{} = poll, attrs \\ %{}) do
    Poll.changeset(poll, attrs)
  end

  alias Survey.PollAdmin.Question

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions do
    Repo.all(Question)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id)

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{data: %Question{}}

  """
  def change_question(%Question{} = question, attrs \\ %{}) do
    Question.changeset(question, attrs)
  end

  alias Survey.PollAdmin.QuestionType

  @doc """
  Returns the list of question_types.

  ## Examples

      iex> list_question_types()
      [%QuestionType{}, ...]

  """
  def list_question_types do
    Repo.all(QuestionType)
  end

  @doc """
  Gets a single question_type.

  Raises `Ecto.NoResultsError` if the Question type does not exist.

  ## Examples

      iex> get_question_type!(123)
      %QuestionType{}

      iex> get_question_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question_type!(id), do: Repo.get!(QuestionType, id)

  def get_question_type_by_name!(name) do
    Repo.get_by(QuestionType, question_type: name)
  end

  @doc """
  Creates a question_type.

  ## Examples

      iex> create_question_type(%{field: value})
      {:ok, %QuestionType{}}

      iex> create_question_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question_type(attrs) do
    %QuestionType{}
    |> QuestionType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question_type.

  ## Examples

      iex> update_question_type(question_type, %{field: new_value})
      {:ok, %QuestionType{}}

      iex> update_question_type(question_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question_type(%QuestionType{} = question_type, attrs) do
    question_type
    |> QuestionType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a question_type.

  ## Examples

      iex> delete_question_type(question_type)
      {:ok, %QuestionType{}}

      iex> delete_question_type(question_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question_type(%QuestionType{} = question_type) do
    Repo.delete(question_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question_type changes.

  ## Examples

      iex> change_question_type(question_type)
      %Ecto.Changeset{data: %QuestionType{}}

  """
  def change_question_type(%QuestionType{} = question_type, attrs \\ %{}) do
    QuestionType.changeset(question_type, attrs)
  end

  alias Survey.PollAdmin.Choice

  @doc """
  Returns the list of choices.

  ## Examples

      iex> list_choices()
      [%Choice{}, ...]

  """
  def list_choices do
    Repo.all(Choice)
  end

  @doc """
  Gets a single choice.

  Raises `Ecto.NoResultsError` if the Choice does not exist.

  ## Examples

      iex> get_choice!(123)
      %Choice{}

      iex> get_choice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_choice!(id), do: Repo.get!(Choice, id)

  @doc """
  Creates a choice.

  ## Examples

      iex> create_choice(%{field: value})
      {:ok, %Choice{}}

      iex> create_choice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_choice(attrs) do
    %Choice{}
    |> Choice.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a choice.

  ## Examples

      iex> update_choice(choice, %{field: new_value})
      {:ok, %Choice{}}

      iex> update_choice(choice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_choice(%Choice{} = choice, attrs) do
    choice
    |> Choice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a choice.

  ## Examples

      iex> delete_choice(choice)
      {:ok, %Choice{}}

      iex> delete_choice(choice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_choice(%Choice{} = choice) do
    Repo.delete(choice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking choice changes.

  ## Examples

      iex> change_choice(choice)
      %Ecto.Changeset{data: %Choice{}}

  """
  def change_choice(%Choice{} = choice, attrs \\ %{}) do
    Choice.changeset(choice, attrs)
  end

  alias Survey.PollAdmin.Answer

  @doc """
  Returns the list of answers.

  ## Examples

      iex> list_answers()
      [%Answer{}, ...]

  """
  def list_answers do
    Repo.all(Answer)
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer!(123)
      %Answer{}

      iex> get_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer!(id), do: Repo.get!(Answer, id)

  # Gets the count of answers for a specific question ID.
  def count_answer_by_question_id!(question_id) do
    from(a in Answer,
      where: a.question_id == ^question_id
    )
    |> Repo.aggregate(:count, :id)
    |> case do
      nil -> 0
      count -> count
    end
  end

  # Count answers per choice (for single or multiple choice questions)
  def count_answers_per_choice!(question_id) do
    from(c in Choice,
      join: a in Answer,
      on: a.choice_id == c.id,
      where: c.question_id == ^question_id,
      group_by: [c.id, c.choice_text],
      select: {c.choice_text, count(a.id)}
    )
    |> Repo.all()
    |> case do
      nil -> 0
      count -> count
    end
  end

  # Count votes per choice across all questions in a poll
  def count_votes_per_choice!(poll_id) do
    from(q in Question,
      where: q.poll_id == ^poll_id,
      join: c in Choice,
      on: c.question_id == q.id,
      left_join: a in Answer,
      on: a.choice_id == c.id,
      group_by: [q.id, q.question_text, c.id, c.choice_text],
      order_by: [q.id],
      select: {q.question_text, c.choice_text, count(a.id)}
    )
    |> Repo.all()
  end

  def count_votes_per_question_and_choice() do
    from(a in Answer,
      join: c in Choice,
      on: c.id == a.choice_id,
      group_by: [c.question_id, c.id],
      select: {c.question_id, c.id, count(a.id)}
    )
    |> Repo.all()
  end

  def show_question_choices_responses_by_poll_id!(poll_id) do
    from(q in Question,
      where: q.poll_id == ^poll_id,
      join: c in assoc(q, :choices),
      left_join: a in Answer,
      on: a.choice_id == c.id,
      group_by: [q.id, q.question_text, c.id, c.choice_text],
      order_by: [q.id, c.id],
      select: %{
        question_id: q.id,
        question_text: q.question_text,
        choice_id: c.id,
        choice_text: c.choice_text,
        vote_count: count(a.id)
      }
    )
    |> Repo.all()
  end

  def combo_results_by_poll_id!(poll_id) do
    choice_query =
      from q in Question,
        where: q.poll_id == ^poll_id,
        join: c in assoc(q, :choices),
        left_join: a in Answer,
        on: a.choice_id == c.id,
        group_by: [q.id, q.question_text, c.id, c.choice_text],
        order_by: [q.id, c.id],
        select: %{
          question_id: q.id,
          question_text: q.question_text,
          label: c.choice_text,
          count: count(a.id)
        }

    text_query =
      from a in Answer,
        join: q in assoc(a, :question),
        where: q.poll_id == ^poll_id and not is_nil(a.free_text),
        group_by: [q.id, q.question_text, a.free_text],
        select: %{
          question_id: q.id,
          question_text: q.question_text,
          label: fragment("trim(?)", a.free_text),
          count: count(a.id)
        }

    Repo.all(choice_query) ++ Repo.all(text_query)
  end

  @doc """
  Creates a answer.

  ## Examples

      iex> create_answer(%{field: value})
      {:ok, %Answer{}}

      iex> create_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer(attrs) do
    %Answer{}
    |> Answer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer.

  ## Examples

      iex> update_answer(answer, %{field: new_value})
      {:ok, %Answer{}}

      iex> update_answer(answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a answer.

  ## Examples

      iex> delete_answer(answer)
      {:ok, %Answer{}}

      iex> delete_answer(answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer changes.

  ## Examples

      iex> change_answer(answer)
      %Ecto.Changeset{data: %Answer{}}

  """
  def change_answer(%Answer{} = answer, attrs \\ %{}) do
    Answer.changeset(answer, attrs)
  end

  alias Survey.PollAdmin.Response

  @doc """
  Returns the list of responses.

  ## Examples

      iex> list_responses()
      [%Response{}, ...]

  """
  def list_responses do
    Repo.all(Response)
  end

  @doc """
  Gets a single response.

  Raises `Ecto.NoResultsError` if the Response does not exist.

  ## Examples

      iex> get_response!(123)
      %Response{}

      iex> get_response!(456)
      ** (Ecto.NoResultsError)

  """
  def get_response!(id), do: Repo.get!(Response, id)

  def get_response_by_poll_id!(poll_id) do
    from(r in Response,
      where: r.poll_id == ^poll_id
    )
    |> Repo.aggregate(:count, :id)
    |> case do
      nil -> 0
      count -> count
    end
  end

  @doc """
  Creates a response.

  ## Examples

      iex> create_response(%{field: value})
      {:ok, %Response{}}

      iex> create_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_response(attrs) do
    %Response{}
    |> Response.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a response.

  ## Examples

      iex> update_response(response, %{field: new_value})
      {:ok, %Response{}}

      iex> update_response(response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_response(%Response{} = response, attrs) do
    response
    |> Response.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a response.

  ## Examples

      iex> delete_response(response)
      {:ok, %Response{}}

      iex> delete_response(response)
      {:error, %Ecto.Changeset{}}

  """
  def delete_response(%Response{} = response) do
    Repo.delete(response)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking response changes.

  ## Examples

      iex> change_response(response)
      %Ecto.Changeset{data: %Response{}}

  """
  def change_response(%Response{} = response, attrs \\ %{}) do
    Response.changeset(response, attrs)
  end
end
