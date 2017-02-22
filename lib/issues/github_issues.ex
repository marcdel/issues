defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir test@email.com"}]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  defp issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, parse_response(body)}
  end

  defp handle_response({_, %{status_code: _, body: body}}) do
    {:error, parse_response(body)}
  end

  defp parse_response(body), do: Poison.Parser.parse! body
end
