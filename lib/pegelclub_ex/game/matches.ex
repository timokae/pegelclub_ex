defmodule PegelclubEx.Game.Matches do
  import Ecto.Query, warn: false

  alias PegelclubEx.Repo
  alias PegelclubEx.Game.{
    Match, Matches, MatchQuery,
    Scores,
    Player, Players
  }

  def list do
    Repo.all(Match)
  end

  def get!(id) do
    Repo.get!(Match, id)
  end

  def create(attrs) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  def delete(%Match{} = match) do
    Repo.delete(match)
  end

  def list_guests(%Match{} = match) do
    MatchQuery.guests(match)
    |> Repo.all()
  end

  def list_addable_guests(match) do
    guests = match
      |> Matches.list_guests
      |> Enum.map(fn s -> s.player end)

    Players.list_guests() -- guests
  end

  def pudel_king_value(%Match{} = match) do
    match
    |> MatchQuery.with_scores()
    |> Repo.aggregate(:max, :penalty_pudel)
  end

  def sorted_scores(%Match{} = match) do
    match
    |> MatchQuery.with_sorted_scores()
    |> Repo.all()
  end

  def total(%Match{} = match, pudel_king) do
    match
      |> Map.get(:scores)
      |> Enum.filter(fn s -> s.is_present == true end)
      |> Map.new(fn s -> {s.id, Scores.total(s, pudel_king)} end)
  end

  def stats(%Match{} = match) do
    match = Repo.preload(match, scores: :player)

    pudel_king = pudel_king_value(match)

    score_totals =total(match, pudel_king)

    match_total = score_totals
      |> Map.values()
      |> Enum.sum()

    average = match_total / Enum.count(match.scores)

    %{
      pudel_king_value: pudel_king,
      total: match_total,
      score_totals: score_totals,
      average: average
    }
  end

  def all_stats() do
    list()
    |> Map.new(fn match -> {match.id, stats(match)} end)
  end

  def add_player(%Match{} = match, %Player{} = player) do
    Scores.create(%{match_id: match.id, player_id: player.id})
  end

  def create_with_scores(attrs) do
    match = create(attrs)

    case match do
      {:ok, match } ->
        for player <- Players.list_regulars() do
          add_player(match, player)
        end
        {:ok, match}
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
