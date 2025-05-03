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

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-8 px-4">
      <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold">Opinion Polls</h1>
        <.link
          navigate={~p"/polls/new"}
          class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded"
        >
          Create New Poll
        </.link>
      </div>
      <div class="bg-white shadow-md rounded-lg p-6">
        <%= if @polls == [] do %>
          <div class="text-center py-4">
            <p class="text-gray-500">No polls available. Create a new poll to get started!</p>
          </div>
        <% else %>
          <div class="mt-6">
            <p class="text-gray-600 mb-4">
              Here are the current polls you can participate in. Click on a poll title to view details and vote.
            </p>
            <p class="text-gray-500 mb-2">Total Polls: {length(@polls)}</p>
            <.table id="polls" rows={@polls}>
              <:col :let={poll} label="Title">
                <.link href={~p"/polls/#{poll.id}"} class="text-indigo-600 hover:text-indigo-800">
                  {poll.title}
                </.link>
              </:col>
              <:col :let={poll} label="Description">{poll.description}</:col>
              <:col :let={poll} label="Status">
                {poll.status |> Atom.to_string() |> String.capitalize()}
              </:col>
              <:col :let={poll} label="">
                <.link navigate={~p"/polls/#{poll.id}/edit"} class="ml-2">
                  Edit
                </.link>
              </:col>
              <:col :let={poll} label="">
                <.link navigate={~p"/polls/#{poll.id}/results"} class="ml-2">
                  Results
                </.link>
              </:col>
              <:col :let={poll} label="">
                <.link
                  href="#"
                  phx-click="delete_poll"
                  phx-value-id={poll.id}
                  data-confirm="Are you sure?"
                  class="bg-red-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded"
                >
                  Delete
                </.link>
              </:col>
            </.table>
          </div>
        <% end %>
        <div class="mt-10 text-center">
          <h2 class="text-xl font-semibold mb-4">About Opinion Polls</h2>
          <p class="text-gray-600 max-w-2xl mx-auto">
            Create and share polls to gather opinions on any topic. See real-time results as people vote,
            and get insights from the responses. It's a great way to make decisions, gather feedback,
            or just have fun!
          </p>
        </div>
      </div>
    </div>
    """
  end
end
