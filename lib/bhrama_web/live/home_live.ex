defmodule BhramaWeb.HomeLive do
  use Phoenix.LiveView,
    container: {:div, [class: "fixed right-0 bottom-0 mr-4 w-4/5"]}

  alias Phoenix.LiveView.JS

  alias BhramaWeb.CoreComponents

  alias Bhrama.Chatbot
  alias Bhrama.Chatbot.Message

  @impl true
  def mount(params, _session, socket) do
    class = Map.get(params, "class", "5")
    username = Map.get(params, "username", "rambo")

    existing_conversation = Chatbot.get_chatbot_conversation_by_name(username)

    conversation =
      if existing_conversation == nil do
        {:ok, conversation} = Chatbot.create_conversation(%{name: username})
        conversation
      else
        existing_conversation
      end

    {
      :ok,
      socket
      |> assign(:conversation, conversation)
      |> assign(:message, %Message{})
      |> assign(:typing, false)
      |> assign(:class, convert_string(class))
      |> assign(:depth, get_depth(class))
      |> assign(:messages, Chatbot.list_messages(conversation))
    }
  end

  @impl true
  def handle_info({BhramaWeb.ChatbotLive.FormComponent, {:saved, message}}, socket) do
    messages = [message | socket.assigns.messages]

    Task.async(fn ->
      Chatbot.generate_response(socket.assigns.conversation, messages,
        class: socket.assigns.class,
        depth: socket.assigns.depth
      )
    end)

    {
      :noreply,
      socket
      |> assign(:message, %Message{})
      |> assign(:messages, messages)
      |> assign(:typing, true)
    }
  end

  def handle_info({ref, result}, socket) do
    Process.demonitor(ref, [:flush])

    messages =
      case result do
        {:ok, message} -> [message | socket.assigns.messages]
        _ -> socket.assigns.messages
      end

    {
      :noreply,
      socket
      |> assign(:messages, messages)
      |> assign(:typing, false)
    }
  end

  def as_html(txt) do
    txt
    |> Earmark.as_html!(escape: false)
    |> Phoenix.HTML.raw()
  end

  defp get_depth(class) do
    res =
      case class do
        "1" -> "Elementary (Grade 1-6)"
        "2" -> "Elementary (Grade 1-6)"
        "3" -> "Elementary (Grade 1-6)"
        "4" -> "Elementary (Grade 1-6)"
        "5" -> "Elementary (Grade 1-6)"
        "6" -> "Elementary (Grade 1-6)"
        "7" -> "Middle School (Grade 7-9)"
        "8" -> "Middle School (Grade 7-9)"
        "9" -> "Middle School (Grade 7-9)"
        "10" -> "High School (Grade 10-12)"
        "11" -> "High School (Grade 10-12)"
        "12" -> "High School (Grade 10-12)"
        "undergraduate" <> _ -> "Undergraduate"
        "graduate" <> _ -> "Graduate (Bachelor Degree)"
        "master" <> _ -> "Master's Degree"
        "doctoral" <> _ -> "Doctoral Candidate (Ph.D Candidate)"
        "phd" <> _ -> "Ph.D"
        "postdoc" <> _ -> "Postdoc"
        _ -> ""
      end

    res
  end

  def convert_string(input) when is_binary(input) do
    case Integer.parse(input) do
      {number, _} when is_integer(number) ->
        convert_number(number)

      _ ->
        String.capitalize(input)
    end
  end

  defp convert_number(number) when number in 11..13 do
    "#{number}th grade"
  end

  defp convert_number(number) when rem(number, 10) == 1 do
    "#{number}st grade"
  end

  defp convert_number(number) when rem(number, 10) == 2 do
    "#{number}nd grade"
  end

  defp convert_number(number) when rem(number, 10) == 3 do
    "#{number}rd grade"
  end

  defp convert_number(number) do
    "#{number}th grade"
  end
end
