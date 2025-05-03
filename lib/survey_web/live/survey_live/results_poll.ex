defmodule SurveyWeb.SurveyLive.ResultsPoll do
  use SurveyWeb, :live_view

  alias Survey.PollAdmin

  @impl true
  def mount(params, _session, socket) do
    poll_id = String.to_integer(params["id"])
    poll_response_count = PollAdmin.get_response_by_poll_id!(poll_id)
    # results = PollAdmin.show_question_choices_responses_by_poll_id!(poll_id)
    raw_data = PollAdmin.combo_results_by_poll_id!(poll_id)

    chart_data =
      raw_data
      |> Enum.group_by(& &1.question_text)
      |> Enum.into(%{}, fn {question, entries} ->
        {question, Enum.map(entries, fn %{label: l, count: c} -> %{label: l, count: c} end)}
      end)

    {:ok,
     socket
     |> assign(poll_id: poll_id)
     |> assign(poll_response_count: poll_response_count)
     # |> assign(results: results)
     |> assign(chart_data: chart_data)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-8 px-4">
      <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold">Poll Results</h1>
        <.link
          navigate={~p"/polls/#{@poll_id}"}
          class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded"
        >
          Back
        </.link>
      </div>
      <div class="bg-white shadow-md rounded-lg p-6">
        <h2 class="text-2xl font-semibold mb-4">Total Responses: {@poll_response_count}</h2>

        <%= for {question, data} <- @chart_data do %>
          <div class="mb-8">
            <h2 class="text-xl font-semibold mb-2">{question}</h2>
            <canvas
              id={"chart-#{Base.encode64(question) |> String.replace(~r/\W/, "")}"}
              phx-hook="PollChart"
              data-values={Jason.encode!(data)}
            >
            </canvas>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
