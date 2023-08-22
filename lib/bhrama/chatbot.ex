defmodule Bhrama.Chatbot do
  @moduledoc """
  The Chatbot context.
  """
  import Ecto.Query, warn: false
  alias Bhrama.Repo

  alias Bhrama.Chatbot.{Conversation, Message, OpenaiService}

  def list_chatbot_conversations do
    Repo.all(Conversation)
  end

  def get_chatbot_conversation_by_name(name) do
    query = from(c in Conversation, where: c.name == ^name)

    Repo.one(query)
  end

  def create_conversation(attrs \\ %{}) do
    %Conversation{}
    |> Conversation.changeset(attrs)
    |> Repo.insert()
  end

  def update_conversation(%Conversation{} = conversation, attrs) do
    conversation
    |> Conversation.changeset(attrs)
    |> Repo.update()
  end

  def list_messages(conversation) do
    query =
      from(m in Message,
        where: m.conversation_id == ^conversation.id,
        limit: 10,
        order_by: [desc: m.inserted_at]
      )

    Repo.all(query)
  end

  def create_message(conversation, attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:conversation, conversation)
    |> Repo.insert()
  end

  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  def generate_response(conversation, messages, opts \\ []) do
    last_messages =
      Enum.slice(messages, 0..15)
      |> Enum.map(fn %{role: role, content: content} ->
        %{"role" => role, "content" => content}
      end)
      |> Enum.reverse()

    create_message(
      conversation,
      OpenaiService.call(last_messages,
        name: conversation.name,
        class: opts[:class],
        depth: opts[:depth]
      )
    )
  end
end
