defmodule Bhrama.Repo do
  use Ecto.Repo,
    otp_app: :bhrama,
    adapter: Ecto.Adapters.Postgres
end
