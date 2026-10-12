defmodule Chirp.Repo do
  use Ecto.Repo,
    otp_app: :chirp,
    adapter: Ecto.Adapters.SQLite3
end
