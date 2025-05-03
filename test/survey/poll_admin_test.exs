defmodule Survey.PollAdminTest do
  use Survey.DataCase

  alias Survey.PollAdmin

  describe "polls" do
    alias Survey.PollAdmin.Poll

    import Survey.PollAdminFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_polls/0 returns all polls" do
      poll = poll_fixture()
      assert PollAdmin.list_polls() == [poll]
    end

    test "get_poll!/1 returns the poll with given id" do
      poll = poll_fixture()
      assert PollAdmin.get_poll!(poll.id) == poll
    end

    test "create_poll/1 with valid data creates a poll" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %Poll{} = poll} = PollAdmin.create_poll(valid_attrs)
      assert poll.description == "some description"
      assert poll.title == "some title"
    end

    test "create_poll/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PollAdmin.create_poll(@invalid_attrs)
    end

    test "update_poll/2 with valid data updates the poll" do
      poll = poll_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Poll{} = poll} = PollAdmin.update_poll(poll, update_attrs)
      assert poll.description == "some updated description"
      assert poll.title == "some updated title"
    end

    test "update_poll/2 with invalid data returns error changeset" do
      poll = poll_fixture()
      assert {:error, %Ecto.Changeset{}} = PollAdmin.update_poll(poll, @invalid_attrs)
      assert poll == PollAdmin.get_poll!(poll.id)
    end

    test "delete_poll/1 deletes the poll" do
      poll = poll_fixture()
      assert {:ok, %Poll{}} = PollAdmin.delete_poll(poll)
      assert_raise Ecto.NoResultsError, fn -> PollAdmin.get_poll!(poll.id) end
    end

    test "change_poll/1 returns a poll changeset" do
      poll = poll_fixture()
      assert %Ecto.Changeset{} = PollAdmin.change_poll(poll)
    end
  end

  describe "questions" do
    alias Survey.PollAdmin.Question

    import Survey.PollAdminFixtures

    @invalid_attrs %{title: nil}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert PollAdmin.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert PollAdmin.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Question{} = question} = PollAdmin.create_question(valid_attrs)
      assert question.title == "some title"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PollAdmin.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Question{} = question} = PollAdmin.update_question(question, update_attrs)
      assert question.title == "some updated title"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = PollAdmin.update_question(question, @invalid_attrs)
      assert question == PollAdmin.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = PollAdmin.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> PollAdmin.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = PollAdmin.change_question(question)
    end
  end

  describe "question_types" do
    alias Survey.PollAdmin.QuestionType

    import Survey.PollAdminFixtures

    @invalid_attrs %{type: nil}

    test "list_question_types/0 returns all question_types" do
      question_type = question_type_fixture()
      assert PollAdmin.list_question_types() == [question_type]
    end

    test "get_question_type!/1 returns the question_type with given id" do
      question_type = question_type_fixture()
      assert PollAdmin.get_question_type!(question_type.id) == question_type
    end

    test "create_question_type/1 with valid data creates a question_type" do
      valid_attrs = %{type: "some type"}

      assert {:ok, %QuestionType{} = question_type} = PollAdmin.create_question_type(valid_attrs)
      assert question_type.type == "some type"
    end

    test "create_question_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PollAdmin.create_question_type(@invalid_attrs)
    end

    test "update_question_type/2 with valid data updates the question_type" do
      question_type = question_type_fixture()
      update_attrs = %{type: "some updated type"}

      assert {:ok, %QuestionType{} = question_type} = PollAdmin.update_question_type(question_type, update_attrs)
      assert question_type.type == "some updated type"
    end

    test "update_question_type/2 with invalid data returns error changeset" do
      question_type = question_type_fixture()
      assert {:error, %Ecto.Changeset{}} = PollAdmin.update_question_type(question_type, @invalid_attrs)
      assert question_type == PollAdmin.get_question_type!(question_type.id)
    end

    test "delete_question_type/1 deletes the question_type" do
      question_type = question_type_fixture()
      assert {:ok, %QuestionType{}} = PollAdmin.delete_question_type(question_type)
      assert_raise Ecto.NoResultsError, fn -> PollAdmin.get_question_type!(question_type.id) end
    end

    test "change_question_type/1 returns a question_type changeset" do
      question_type = question_type_fixture()
      assert %Ecto.Changeset{} = PollAdmin.change_question_type(question_type)
    end
  end

  describe "choices" do
    alias Survey.PollAdmin.Choice

    import Survey.PollAdminFixtures

    @invalid_attrs %{position: nil, choice_text: nil}

    test "list_choices/0 returns all choices" do
      choice = choice_fixture()
      assert PollAdmin.list_choices() == [choice]
    end

    test "get_choice!/1 returns the choice with given id" do
      choice = choice_fixture()
      assert PollAdmin.get_choice!(choice.id) == choice
    end

    test "create_choice/1 with valid data creates a choice" do
      valid_attrs = %{position: 42, choice_text: "some choice_text"}

      assert {:ok, %Choice{} = choice} = PollAdmin.create_choice(valid_attrs)
      assert choice.position == 42
      assert choice.choice_text == "some choice_text"
    end

    test "create_choice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PollAdmin.create_choice(@invalid_attrs)
    end

    test "update_choice/2 with valid data updates the choice" do
      choice = choice_fixture()
      update_attrs = %{position: 43, choice_text: "some updated choice_text"}

      assert {:ok, %Choice{} = choice} = PollAdmin.update_choice(choice, update_attrs)
      assert choice.position == 43
      assert choice.choice_text == "some updated choice_text"
    end

    test "update_choice/2 with invalid data returns error changeset" do
      choice = choice_fixture()
      assert {:error, %Ecto.Changeset{}} = PollAdmin.update_choice(choice, @invalid_attrs)
      assert choice == PollAdmin.get_choice!(choice.id)
    end

    test "delete_choice/1 deletes the choice" do
      choice = choice_fixture()
      assert {:ok, %Choice{}} = PollAdmin.delete_choice(choice)
      assert_raise Ecto.NoResultsError, fn -> PollAdmin.get_choice!(choice.id) end
    end

    test "change_choice/1 returns a choice changeset" do
      choice = choice_fixture()
      assert %Ecto.Changeset{} = PollAdmin.change_choice(choice)
    end
  end

  describe "answers" do
    alias Survey.PollAdmin.Answer

    import Survey.PollAdminFixtures

    @invalid_attrs %{free_text: nil}

    test "list_answers/0 returns all answers" do
      answer = answer_fixture()
      assert PollAdmin.list_answers() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert PollAdmin.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      valid_attrs = %{free_text: "some free_text"}

      assert {:ok, %Answer{} = answer} = PollAdmin.create_answer(valid_attrs)
      assert answer.free_text == "some free_text"
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PollAdmin.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      update_attrs = %{free_text: "some updated free_text"}

      assert {:ok, %Answer{} = answer} = PollAdmin.update_answer(answer, update_attrs)
      assert answer.free_text == "some updated free_text"
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = PollAdmin.update_answer(answer, @invalid_attrs)
      assert answer == PollAdmin.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = PollAdmin.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> PollAdmin.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = PollAdmin.change_answer(answer)
    end
  end

  describe "responses" do
    alias Survey.PollAdmin.Response

    import Survey.PollAdminFixtures

    @invalid_attrs %{submitted_at: nil}

    test "list_responses/0 returns all responses" do
      response = response_fixture()
      assert PollAdmin.list_responses() == [response]
    end

    test "get_response!/1 returns the response with given id" do
      response = response_fixture()
      assert PollAdmin.get_response!(response.id) == response
    end

    test "create_response/1 with valid data creates a response" do
      valid_attrs = %{submitted_at: ~N[2025-04-18 15:46:00]}

      assert {:ok, %Response{} = response} = PollAdmin.create_response(valid_attrs)
      assert response.submitted_at == ~N[2025-04-18 15:46:00]
    end

    test "create_response/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PollAdmin.create_response(@invalid_attrs)
    end

    test "update_response/2 with valid data updates the response" do
      response = response_fixture()
      update_attrs = %{submitted_at: ~N[2025-04-19 15:46:00]}

      assert {:ok, %Response{} = response} = PollAdmin.update_response(response, update_attrs)
      assert response.submitted_at == ~N[2025-04-19 15:46:00]
    end

    test "update_response/2 with invalid data returns error changeset" do
      response = response_fixture()
      assert {:error, %Ecto.Changeset{}} = PollAdmin.update_response(response, @invalid_attrs)
      assert response == PollAdmin.get_response!(response.id)
    end

    test "delete_response/1 deletes the response" do
      response = response_fixture()
      assert {:ok, %Response{}} = PollAdmin.delete_response(response)
      assert_raise Ecto.NoResultsError, fn -> PollAdmin.get_response!(response.id) end
    end

    test "change_response/1 returns a response changeset" do
      response = response_fixture()
      assert %Ecto.Changeset{} = PollAdmin.change_response(response)
    end
  end
end
