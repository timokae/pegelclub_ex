defmodule PegelclubExWeb.Helpers do

  def currency_format(number) do
    [:erlang.float_to_binary(number / 100, [decimals: 2]), "€"]
    |> Enum.join(" ")
  end

  def dom_id(%{id: id}, prefix) when is_list(prefix) do
    prefix
    |> Kernel.++([id])
    |> Enum.join("_")
  end

  def dom_id(%{id: id}, prefix) when is_binary(prefix) do
    "#{prefix}_#{id}"
  end
end
