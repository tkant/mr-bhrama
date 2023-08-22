defmodule Bhrama.Chatbot.OpenaiService do
  alias Bhrama.Chatbot.Prompts

  defp default_system_prompt do
    """
    You are a chatbot that only answers questions about the programming language Elixir.
    Answer short with just a 1-3 sentences.
    If the question is about another programming language, make a joke about it.
    If the question is about something else, answer something like:
    "I dont know, its not my cup of tea" or "I have no opinion about that topic".
    """
  end

  def call(prompts, opts \\ []) do
    # Simply generating a conversation with entered username
    # As of now we are only using 3 different prompts
    # - High School Student
    # - Undergraduate Student
    # - Elixir programming language learner
    default_prompts =
      case opts[:name] do
        "ram" ->
          Prompts.high_school_student_prompt()

        "shyam" ->
          Prompts.undergraduate_student_prompt()

        "elixir" ->
          default_system_prompt()

        _ ->
          Prompts.generic_student_prompt(name: opts[:name], class: opts[:class], depth: opts[:depth])
      end

    %{
      "model" => "gpt-4",
      "messages" =>
        Enum.concat(
          [
            %{"role" => "system", "content" => default_prompts}
          ],
          prompts
        ),
      "temperature" => 0.7
    }
    |> Jason.encode!()
    |> request(opts)
    |> parse_response()
  end

  defp parse_response({:ok, %Finch.Response{body: body}}) do
    messages =
      Jason.decode!(body)
      |> Map.get("choices", [])
      |> Enum.reverse()

    case messages do
      [%{"message" => message} | _] -> message
      _ -> "{}"
    end
  end

  defp parse_response(error) do
    error
  end

  defp request(body, opts) do
    Finch.build(:post, "https://api.openai.com/v1/chat/completions", headers(), body)
    |> Finch.request(Bhrama.Finch, pool_timeout: 200_000, receive_timeout: 200_000)
  end

  defp headers do
    [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{Application.get_env(:bhrama, :open_ai_api_key)}"}
    ]
  end
end
