defmodule SurveyWeb.SurveyLive.NewPoll do
  use SurveyWeb, :live_view

  alias Survey.PollAdmin
  alias Survey.PollAdmin.Poll
  alias Survey.PollAdmin.Choice

  @impl true
  def mount(_params, _session, socket) do
    changeset = PollAdmin.change_poll(%Poll{})
    choices = PollAdmin.change_choice(%Choice{})

    poll_status =
      %{"draft" => "draft", "active" => "active", "closed" => "closed"}
      |> Enum.map(fn {key, value} -> {key, value} end)

    question_types =
      PollAdmin.list_question_types()
      |> Enum.map(&{&1.question_type, &1.id})

    _filter_dropdown =
      %{"active" => "Active", "draft" => "Draft", "closed" => "Closed"}
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
    case PollAdmin.create_poll(poll_params) |> dbg do
      {:ok, poll} ->
        {:noreply, redirect(socket, to: "/polls/#{poll.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("validate", %{"poll" => poll_params}, socket) do
    changeset = PollAdmin.change_poll(%Poll{}, poll_params)
    error_message = if changeset.valid?, do: nil, else: "Please fix the errors below."
    {:noreply, assign(socket, changeset: changeset, error_message: error_message)}
  end

  def handle_event("question_type_selected", %{"question_type" => question_type_id}, socket) do
    IO.inspect(question_type_id, label: "Selected Question Type ID")
    {:noreply, socket |> assign(selected_question_type: question_type_id)}
  end

  def handle_event("question_type_selected", _params, socket) do
    # Handle the case where no question type is selected
    IO.inspect("No question type selected", label: "Warning")
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-8 px-4">
      <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold">Create a New Poll</h1>
      </div>
      <div class="bg-white shadow-md rounded-lg p-6">
        <.form :let={poll} for={@changeset} phx-submit="save" phx-change="validate">
          <%= if @error_message do %>
            <div class="bg-red-50 p-4 rounded-md mb-4">
              <div class="flex">
                <div class="flex-shrink-0">
                  <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                    <path
                      fill-rule="evenodd"
                      d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </div>
                <div class="space-y-6">
                  <h3 class="text-sm font-medium text-red-800">{@error_message}</h3>
                </div>
              </div>
            </div>
          <% end %>
          <div class="mb-4">
            <.input field={poll[:title]} type="text" label="Poll Title" class="w-full" />
          </div>
          <div class="mb-4">
            <.input
              field={poll[:description]}
              type="textarea"
              label="Description (Optional)"
              placeholder="Provide some context for your poll"
              class="w-full"
            />
          </div>
          <div class="mb-4">
            <.input field={poll[:status]} label="Status" type="select" options={@poll_status} />
          </div>
          <div class="border-t border-gray-200 pt-6">
            <h3 class="text-lg font-medium text-gray-900">Questions</h3>
            <p class="mt-1 text-sm text-gray-500">Create one or more questions for your poll.</p>
          </div>
          <div id="questions" class="mt-6">
            <.inputs_for :let={poll_questions} field={poll[:questions]}>
              <input type="hidden" name="poll[questions_sort][]" value={poll_questions.index} />
              <div class="mb-4">
                <.input
                  field={poll_questions[:question_text]}
                  type="text"
                  label="Question Text"
                  required
                  class="w-full"
                />
                <div class="mt-2">
                  <p class="text-sm text-gray-500">
                    Select the type of question. The options will vary based on the type selected.
                  </p>
                </div>
                <.input
                  field={poll_questions[:question_type_id]}
                  label="Question Type"
                  type="select"
                  options={@question_types}
                />
                <!-- Display choices based on selected question type -->
                <.inputs_for :let={ch} field={poll_questions[:choices]}>
                  <input
                    type="hidden"
                    name={"poll[questions][#{poll_questions.index}][choices_sort][]"}
                    value={ch.index}
                  />

                  <div class="mb-2">
                    <.input
                      field={ch[:choice_text]}
                      type="text"
                      label="Choice Text"
                      placeholder="Enter choice text"
                      class="w-full"
                    />
                  </div>
                  <button
                    type="button"
                    name={"poll[questions][#{poll_questions.index}][choices_drop][]"}
                    value={poll_questions.index}
                    phx-click={JS.dispatch("change")}
                    class="px-4 py-2 rounded-md font-medium bg-red-700 text-white shadow-lg"
                  >
                    Remove Choice
                  </button>
                </.inputs_for>

                <button
                  type="button"
                  name={"poll[questions][#{poll_questions.index}][choices_sort][]"}
                  value="new"
                  phx-click={JS.dispatch("change")}
                  class="px-4 py-2 rounded-md font-medium bg-indigo-600 text-white shadow-lg"
                >
                  Add Choice
                </button>
                
    <!-- End of choices section -->
                <div class="mt-2">
                  <button
                    type="button"
                    name="poll[questions_drop][]"
                    value={poll_questions.index}
                    phx-click={JS.dispatch("change")}
                    class="px-4 py-2 rounded-md font-medium bg-red-700 text-white shadow-lg"
                  >
                    Remove Question
                  </button>
                </div>
              </div>
            </.inputs_for>
            <input type="hidden" name="poll[questions_drop][]" />
            <button
              type="button"
              name="poll[questions_sort][]"
              value="new"
              phx-click={JS.dispatch("change")}
              class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded"
            >
              Add Question
            </button>
          </div>

          <div class="flex justify-left mt-6">
            <.button phx-disable-with="Saving...">Save</.button>
          </div>
        </.form>
      </div>
    </div>
    """
  end
end
