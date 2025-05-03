defmodule SurveyWeb.SurveyLive.EditPoll do
  use SurveyWeb, :live_view

  alias Survey.PollAdmin

  @impl true
  def mount(_params, _session, socket) do
    polls = PollAdmin.list_polls()
    {:ok, assign(socket, polls: polls)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto py-8 px-4">
      <h1 class="text-3xl font-bold mb-6">Edit Poll</h1>
      <form phx-submit="save" class="space-y-4">
        <div class="flex justify-end">
          <button
            type="submit"
            class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded"
          >
            Save Changes
          </button>
        </div>
      </form>
    </div>
    """
  end
end
