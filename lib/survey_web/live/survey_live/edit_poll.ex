defmodule SurveyWeb.SurveyLive.EditPoll do
  use SurveyWeb, :live_view

  alias Survey.PollAdmin

  @impl true
  def mount(params, _session, socket) do
    poll_id = String.to_integer(params["id"])
    poll = PollAdmin.get_poll!(poll_id) |> dbg()
    changeset = PollAdmin.change_poll(poll)

    question_types =
      PollAdmin.list_question_types()
      |> Enum.map(&{&1.question_type, &1.id})

    choices = PollAdmin.change_choice(%Survey.PollAdmin.Choice{})

    poll_status =
      %{"draft" => "draft", "active" => "active", "closed" => "closed"}
      |> Enum.map(fn {key, value} -> {key, value} end)

    {:ok,
     socket
     |> assign(changeset: changeset)
     |> assign(error_message: nil)
     |> assign(question_types: question_types)
     |> assign(selected_question_type: nil)
     |> assign(choices: choices)
     |> assign(poll_status: poll_status)}
  end

  @impl true
  def handle_event("save", %{"poll" => poll_params}, socket) do
    case PollAdmin.update_poll(socket.assigns.poll, poll_params) do
      {:ok, poll} ->
        {:noreply, redirect(socket, to: "/polls/#{poll.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto py-8 px-4">
      <h1 class="text-3xl font-bold mb-6">Edit Poll</h1>
      <div class="bg-white shadow-md rounded-lg p-6">
        <.form :let={poll} for={@changeset} phx-submit="save" phx-change="validate">
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700">Title</label>
            <.input
              type="text"
              name="poll[title]"
              value={poll.data.title}
              class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              required
            />
          </div>
          <div class="mb-4">
            <.input
              name="poll[description]"
              type="textarea"
              label="Description"
              value={poll.data.description}
              class="w-full"
            />
          </div>
          <div class="border-t border-gray-200 pt-6">
            <h3 class="text-lg font-medium text-gray-900">Questions</h3>
            <p class="mt-1 text-sm text-gray-500">Create one or more questions for your poll.</p>
          </div>
          <div id="questions" class="mt-6">
            <.inputs_for :let={poll_questions} field={poll[:questions]}>
              <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700">Question Text</label>
                <.input
                  type="text"
                  name="poll[questions][question_text]"
                  value={poll_questions.data.question_text}
                  class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                  required
                />
              </div>
              <div id="choices" class="mb-4">
                <h4 class="text-sm font-medium text-gray-700">Choices</h4>
                <.inputs_for :let={choices} field={poll_questions[:choices]}>
                  <div class="flex items-center mb-2">
                    <.input
                      type="text"
                      name="poll[questions][choices][choice_text]"
                      value={choices.data.choice_text}
                      class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                      required
                    />
                  </div>
                </.inputs_for>
              </div>
            </.inputs_for>
          </div>

          <div class="flex justify-end">
            <button
              type="submit"
              class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded"
            >
              Save Changes
            </button>
          </div>
        </.form>
      </div>
    </div>
    """
  end
end
