defmodule TabularDemo.Repo do
  use Ecto.Repo,
    otp_app: :tabular_demo,
    adapter: Ecto.Adapters.Postgres
end
