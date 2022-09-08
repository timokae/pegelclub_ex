defmodule PegelclubExWeb.ScoreView do
  use PegelclubExWeb, :view

  def guest_select_options(players) do
    players
    |> Enum.map(fn p -> [key: p.name, value: p.id] end)
  end

  def penalty_decrease_button(target) do
    penalty_button(target, -1, "ri-subtract-line")
  end

  def penalty_increase_button(target) do
    penalty_button(target, 1, "ri-add-line")
  end

  def penalty_button(target, value, icon) do
    content_tag(
      :button,
      type: "button",
      class: "button has-no-min-width",
      data_penalty_target: "score_#{Atom.to_string(target)}",
      data_penalty_direction_value: value
    ) do
      content_tag(:span, class: "icon") do
        content_tag(:i, "", class: "#{icon} ri-xl")
      end
    end
  end

  def title(name) do
    if String.ends_with?(name, "s") do
      name
    else
      name <> "s"
    end
  end
end
