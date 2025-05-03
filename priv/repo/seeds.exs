# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Survey.Repo.insert!(%Survey.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Survey.Repo
# alias Survey.PollAdmin
# Ensure the database is empty before seeding
Repo.delete_all(Survey.PollAdmin.Question)
Repo.delete_all(Survey.PollAdmin.QuestionType)
Repo.delete_all(Survey.PollAdmin.Choice)
Repo.delete_all(Survey.PollAdmin.Poll)
Repo.delete_all(Survey.PollAdmin.Response)
Repo.delete_all(Survey.PollAdmin.Answer)
# Create question types
question_types = ["single_choice", "multiple_choice", "free_text", "Rating"]

for type <- question_types do
  {:ok, question_type} = Survey.PollAdmin.create_question_type(%{question_type: type})
end

IO.puts("🌱 Seeding poll data...")

{:ok, poll} =
  Survey.PollAdmin.create_poll(%{
    title: "Tech Preferences Survey",
    description: "Tell us about your favorite technologies!",
    status: "active"
  })

questions = [
  %{
    question_text: "Which programming language do you use the most?",
    question_type: "single_choice",
    choices: ["Elixir", "JavaScript", "Python", "Rust"]
  },
  %{
    question_text: "Which editors do you use?",
    question_type: "multiple_choice",
    choices: ["VS Code", "Neovim", "JetBrains", "Emacs"]
  },
  %{
    question_text: "Why do you love programming?",
    question_type: "free_text",
    # no choices for free-text
    choices: []
  }
]

for question <- questions do
  question_type_id =
    case question.question_type do
      "single_choice" ->
        Survey.PollAdmin.get_question_type_by_name!("single_choice").id

      "multiple_choice" ->
        Survey.PollAdmin.get_question_type_by_name!("multiple_choice").id

      "free_text" ->
        Survey.PollAdmin.get_question_type_by_name!("free_text").id

      _ ->
        raise "Unknown question type: #{question.question_type}"
    end

  {:ok, created_question} =
    Survey.PollAdmin.create_question(%{
      question_text: question.question_text,
      poll_id: poll.id,
      question_type_id: question_type_id,
      position: 1
    })

  for {choice_text, index} <- Enum.with_index(question.choices) do
    {:ok, _} =
      Survey.PollAdmin.create_choice(%{
        choice_text: choice_text,
        position: index + 1,
        question_id: created_question.id
      })
  end
end

IO.puts("✅ Poll, questions, and choices created.")
