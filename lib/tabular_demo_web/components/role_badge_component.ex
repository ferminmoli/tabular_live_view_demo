defmodule TabularDemoWeb.Components.RoleBadgeComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <span class={"inline-block px-2 py-1 rounded text-xs font-bold #{color(@row.role)}"}>
      <%= @row.role %>
    </span>
    """
  end

  defp color("Admin"), do: "bg-red-100 text-red-800"
  defp color("User"), do: "bg-blue-100 text-blue-800"
  defp color("Guest"), do: "bg-gray-100 text-gray-600"
  defp color(_), do: "bg-yellow-100 text-yellow-800"
end
