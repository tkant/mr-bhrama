defmodule Bhrama.Repo.Migrations.CreateChatbotConversations do
  use Ecto.Migration

  def change do
    create table(:chatbot_conversations) do
      add :resolved_at, :naive_datetime
      add :name, :string

      timestamps()
    end

    create unique_index(:chatbot_conversations, [:name])
  end
end
