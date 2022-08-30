defmodule PegelclubExWeb.PageController do
  use PegelclubExWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
