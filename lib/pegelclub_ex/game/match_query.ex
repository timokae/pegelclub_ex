defmodule PegelclubEx.Game.MatchQuery do
  import Ecto.Query, warn: false

  alias PegelclubEx.Game.{Match, Score}

  def all do
    from m in Match,
      order_by: :played_at
  end

  def with_scores(%Match{} = match) do
    from s in Score,
      where: s.match_id == ^match.id
  end

  def guests(%Match{} = match) do
    from s in Score,
      join: p in assoc(s, :player),
      where: s.match_id == ^match.id and p.guest == true,
      select: s,
      preload: [player: p]
  end

  def with_sorted_scores(%Match{} = match) do
    from s in with_scores(match),
      left_join: p in assoc(s, :player),
      order_by: [asc: p.name],
      preload: :player
  end
end
