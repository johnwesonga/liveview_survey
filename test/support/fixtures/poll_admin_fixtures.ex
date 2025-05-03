defmodule Survey.PollAdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Survey.PollAdmin` context.
  """

  @doc """
  Generate a poll.
  """
  def poll_fixture(attrs \\ %{}) do
    {:ok, poll} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Survey.PollAdmin.create_poll()

    poll
  end

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Survey.PollAdmin.create_question()

    question
  end

  @doc """
  Generate a question_type.
  """
  def question_type_fixture(attrs \\ %{}) do
    {:ok, question_type} =
      attrs
      |> Enum.into(%{
        type: "some type"
      })
      |> Survey.PollAdmin.create_question_type()

    question_type
  end

  @doc """
  Generate a choice.
  """
  def choice_fixture(attrs \\ %{}) do
    {:ok, choice} =
      attrs
      |> Enum.into(%{
        choice_text: "some choice_text",
        position: 42
      })
      |> Survey.PollAdmin.create_choice()

    choice
  end

  @doc """
  Generate a answer.
  """
  def answer_fixture(attrs \\ %{}) do
    {:ok, answer} =
      attrs
      |> Enum.into(%{
        free_text: "some free_text"
      })
      |> Survey.PollAdmin.create_answer()

    answer
  end

  @doc """
  Generate a response.
  """
  def response_fixture(attrs \\ %{}) do
    {:ok, response} =
      attrs
      |> Enum.into(%{
        submitted_at: ~N[2025-04-18 15:46:00]
      })
      |> Survey.PollAdmin.create_response()

    response
  end
end
