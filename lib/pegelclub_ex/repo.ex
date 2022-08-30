defmodule PegelclubEx.Repo do
  use Ecto.Repo,
    otp_app: :pegelclub_ex,
    adapter: Ecto.Adapters.Postgres
end
