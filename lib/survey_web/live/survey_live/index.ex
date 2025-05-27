defmodule SurveyWeb.SurveyLive.Index do
  use SurveyWeb, :live_view

  alias Survey.PollAdmin

  @impl true
  def mount(_params, _session, socket) do
    polls = PollAdmin.list_polls()
    {:ok, assign(socket, polls: polls, error_message: nil)}
  end

  @impl true
  def handle_event("delete_poll", %{"id" => id}, socket) when is_binary(id) do
    IO.inspect(id, label: "Deleting Poll ID")
    poll = PollAdmin.get_poll!(String.to_integer(id))

    case PollAdmin.delete_poll(poll) do
      {:ok, _poll} ->
        {:noreply, assign(socket, polls: PollAdmin.list_polls())}

      {:error, _reason} ->
        {:noreply, assign(socket, error_message: "Failed to delete poll.")}
    end
  end

  def handle_event("delete_poll", _params, socket) do
    {:noreply, assign(socket, error_message: "Invalid poll ID.")}
  end
end
