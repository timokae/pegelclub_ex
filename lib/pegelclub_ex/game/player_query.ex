defmodule PegelclubEx.Game.PlayerQuery do
  import Ecto.Query, warn: false

  alias PegelclubEx.Game.Player

  def all do
    from p in Player,
      order_by: :name
  end

  def regulars do
    from p in all(),
      where: p.guest == false
  end

  def guests do
    from p in all(),
      where: p.guest == true
  end
end
