defmodule PegelclubEx.Game.PlayerQuery do
  import Ecto.Query, warn: false

  alias PegelclubEx.Game.Player

  def all do
    from p in Player,
      order_by: :name
  end
  def regulars(query \\ Player) do
    from p in query,
      where: p.guest == false
  end

  def active(query \\ Player) do
    from p in query,
      where: p.active == true
  end

  def guests(query \\ Player) do
    from p in query,
      where: p.guest == true
  end
end
