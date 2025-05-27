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

  def handle_event("validate", %{"poll" => poll_params}, socket) do
    changeset = PollAdmin.change_poll(socket.assigns.poll, poll_params)
    error_message = if changeset.valid?, do: nil, else: "Please fix the errors below."
    {:noreply, assign(socket, changeset: changeset, error_message: error_message)}
  end
end
