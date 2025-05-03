defmodule SurveyWeb.SurveyLive.ShowPoll do
  use SurveyWeb, :live_view

  alias Survey.PollAdmin
  alias Survey.PollAdmin.Response

  @impl true
  def mount(params, _session, socket) do
    poll_id = String.to_integer(params["id"])
    poll = PollAdmin.get_poll!(poll_id)
    changeset = PollAdmin.change_response(%Response{})
    {:ok, assign(socket, poll: poll, changeset: changeset, poll_id: poll_id, error_message: nil)}
  end

  def handle_event("validate", %{"response" => %{"answers" => answers_params}}, socket) do
    changeset = PollAdmin.change_response(%Response{}, answers_params)
    error_message = if changeset.valid?, do: nil, else: "Please fix the errors below."
    {:noreply, assign(socket, changeset: changeset, error_message: error_message)}
  end

  @impl true
  def handle_event("save", %{"response" => %{"answers" => answers_params}}, socket) do
    poll_id = socket.assigns.poll_id |> dbg()

    answers_params |> dbg()

    answers =
      answers_params
      |> Map.values()
      |> Enum.map(fn %{"question_id" => qid} = answer ->
        cond do
          is_list(answer["choice_id"]) ->
            Enum.map(answer["choice_id"], fn cid ->
              %{question_id: qid, choice_id: cid}
            end)

          answer["choice_id"] ->
            [%{question_id: qid, choice_id: answer["choice_id"]}]

          answer["free_text"] ->
            [%{question_id: qid, free_text: answer["free_text"]}]
        end
      end)
      |> List.flatten()

    answers |> dbg()
    # Create the response with the answers
    case PollAdmin.create_response(%{
           poll_id: poll_id,
           answers: answers
         }) do
      {:ok, _response} ->
        socket = assign(socket, error_message: nil)
        {:noreply, redirect(socket, to: "/polls/#{poll_id}/results")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
        IO.inspect(changeset, label: "Changeset Error")
        IO.inspect(changeset.errors, label: "Changeset Errors")
        IO.inspect(changeset.valid?, label: "Is Changeset Valid?")
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto py-8 px-4">
      <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold">Opinion Polls</h1>
        <.link
          navigate={~p"/polls/#{@poll.id}/results"}
          class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded"
        >
          View Poll Results
        </.link>
      </div>
      <div class="bg-white shadow-md rounded-lg p-6">
        <h2 class="text-2xl font-semibold mb-4">{@poll.title}</h2>
        <p class="text-sm text-gray-500 mb-4">{@poll.description}</p>
        <p class="text-sm text-gray-500 mb-4">
          Status: {@poll.status |> Atom.to_string() |> String.capitalize()}
        </p>
        <.form for={@changeset} phx-submit="save" phx-change="validate">
          <%= if @error_message do %>
            <div class="bg-red-50 p-4 rounded-md mb-4">
              <div class="flex">
                <p class="text-red-600">{@error_message}</p>
              </div>
            </div>
          <% end %>
          <input type="hidden" name="_csrf_token" value={Phoenix.Controller.get_csrf_token()} />
          <h3 class="text-xl font-semibold mb-2">Questions</h3>
          <div class="mb-4">
            <p class="text-gray-600 mb-4">Please answer the following questions:</p>
            <%= for {question, idx} <- Enum.with_index(@poll.questions, 1) do %>
              <p class="font-semibold">{idx}) {question.question_text}</p>
              <div class="text-sm text-gray-500">
                <%= case question.question_type.question_type do %>
                  <% "single_choice" -> %>
                    <%= for choice <- question.choices do %>
                      <input
                        type="radio"
                        name={"response[answers][#{idx}][choice_id]"}
                        value={choice.id}
                        class="mr-2"
                      />
                      {choice.choice_text} <br />
                    <% end %>
                  <% "multiple_choice" -> %>
                    <.checkgroup
                      name={"response[answers][#{idx}][choice_id][]"}
                      id="genres"
                      options={
                        Enum.map(question.choices, fn choice ->
                          for key <- [:id, :choice_text], into: %{} do
                            {key, to_string(Map.get(choice, key))}
                          end
                        end)
                      }
                    />
                  <% _ -> %>
                    <.input
                      type="textarea"
                      name={"response[answers][#{idx}][free_text]"}
                      value=""
                      placeholder="Your answer here"
                    />
                <% end %>
                <input
                  type="hidden"
                  name={"response[answers][#{idx}][question_id]"}
                  value={question.id}
                />
              </div>
              <br />
            <% end %>
          </div>
          <div class="flex justify-end">
            <.button
              type="submit"
              phx-disable-with="Saving..."
              class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded"
            >
              Submit Answers
            </.button>
          </div>
          <input type="hidden" name="response[poll_id]" value={@poll.id} />
        </.form>
      </div>
    </div>
    """
  end
end
