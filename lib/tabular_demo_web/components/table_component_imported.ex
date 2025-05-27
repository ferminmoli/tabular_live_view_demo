defmodule TabularLiveView.TableComponentImported do
  use Phoenix.LiveComponent
  import Phoenix.LiveView
  import Phoenix.Component

  def update(assigns, socket) do
    opts = Map.get(assigns, :opts, %{})

    socket =
      socket
      |> assign(assigns)
      |> assign_defaults(opts)
      |> update_paginated_rows()

    {:ok, socket}
  end

  defp update_paginated_rows(socket) do
    assign(
      socket,
      :paginated_rows,
      paginate(
        socket.assigns.rows || [],
        socket.assigns.page,
        socket.assigns.page_size,
        socket.assigns.search,
        socket.assigns.sort_by,
        socket.assigns.sort_order,
        socket.assigns.filters
      )
    )
  end

  defp assign_defaults(socket, opts) do
    assign_new(socket, :page, fn -> Map.get(opts, :page, 1) end)
    |> assign_new(:page_size, fn -> Map.get(opts, :page_size, 10) end)
    |> assign_new(:sort_by, fn -> Map.get(opts, :sort_by, nil) end)
    |> assign_new(:sort_order, fn -> Map.get(opts, :sort_order, :asc) end)
    |> assign_new(:search, fn -> "" end)
    |> assign_new(:filters, fn -> Map.get(socket.assigns, :filters, %{}) end)
    |> assign_new(:search_enabled, fn -> Map.get(opts, :search, true) end)
    |> assign_new(:no_results_message, fn ->
      Map.get(opts, :no_results_message, "No se encontraron resultados")
    end)
    |> assign_new(:show_pagination, fn -> Map.get(opts, :pagination, true) end)
    |> assign_new(:export_enabled, fn -> Map.get(opts, :export, false) end)
    |> assign_new(:table_class, fn ->
      Map.get(opts, :table_class, "min-w-full divide-y divide-gray-200")
    end)
    |> assign_new(:header_class, fn ->
      Map.get(opts, :header_class, "px-4 py-2 text-left font-medium text-gray-700")
    end)
    |> assign_new(:cell_class, fn ->
      Map.get(opts, :cell_class, "px-4 py-2 text-sm text-gray-900")
    end)
    |> assign_new(:scroll_x, fn -> Map.get(opts, :scroll_x, false) end)
    |> assign_new(:sticky_header, fn -> Map.get(opts, :sticky_header, false) end)
  end

  def render(assigns) do
    ~H"""
    <div>
      <form phx-change="filter" phx-target={@myself} class="mb-4 flex flex-wrap gap-4">
        <%= for {field, opts} <- @columns, get_filterable(opts) do %>
          <div>
            <label class="block text-sm font-medium text-gray-700"><%= get_label(opts) %></label>
            <select name={to_string(field)} class="border px-2 py-1 rounded">
              <option value="">Todos</option>
              <%= for option <- get_filter_options(opts) do %>
                <option value={option} selected={@filters[to_string(field)] == option}><%= option %></option>
              <% end %>
            </select>
          </div>
        <% end %>
      </form>

      <%= if @search_enabled do %>
        <form phx-change="search" phx-target={@myself}>
          <input type="text" name="search" value={@search} placeholder="Buscar..." phx-debounce="300" class="mb-2 px-2 py-1 border rounded" />
        </form>
      <% end %>

      <%= if @export_enabled do %>
        <form method="get" action="/export.csv">
          <input type="hidden" name="sort_by" value={@sort_by} />
          <input type="hidden" name="sort_order" value={@sort_order} />
          <input type="hidden" name="search" value={@search} />
          <button type="submit" class="mb-2 px-4 py-1 border rounded bg-blue-600 text-white">Descargar CSV</button>
        </form>
      <% end %>
      <div class={@scroll_x && @sticky_header && "overflow-x-auto max-h-[400px] overflow-y-auto" ||
             @scroll_x && "overflow-x-auto" ||
             @sticky_header && "max-h-[400px] overflow-y-auto" ||
             ""}>
      <table class={@table_class}>
      <thead class={if @sticky_header, do: "sticky top-0 z-10 bg-white", else: ""}>
          <tr>
            <%= for {field, opts} <- @columns, get_visible(opts) do %>
              <% label = get_label(opts) %>
              <% sortable = get_sortable(opts) %>
              <% th_class = get_th_class(opts, @header_class) %>
              <th class={"#{th_class} #{if sortable, do: "cursor-pointer", else: ""}"}
                  phx-click={if sortable, do: "sort", else: nil}
                  phx-value-field={if sortable, do: field, else: nil}
                  phx-target={@myself}>
                <%= label %>
                <%= if sortable and @sort_by == field do %>
                  <%= if @sort_order == :asc, do: "↑", else: "↓" %>
                <% end %>
              </th>
            <% end %>
          </tr>
        </thead>
        <tbody>
    <%= if Enum.empty?(@paginated_rows) do %>
    <tr>
    <td class={@cell_class <> " text-center text-gray-500"} colspan={Enum.count(Enum.filter(@columns, fn {_f, o} -> get_visible(o) end))}>
        <%= @no_results_message %>
      </td>
    </tr>
    <% else %>
    <%= for row <- @paginated_rows do %>
      <tr>
      <%= for {field, opts} <- @columns, get_visible(opts) do %>
          <% td_class = get_td_class(opts, @cell_class) %>
          <td class={td_class}>
          <% function = get_renderer(opts) %>
            <% component = get_component(opts) %>
            <% actions = get_actions(opts) %>

            <%= if function do %>
            <%= function.(row) %>
            <% else %>
            <%= if component do %>
            <.live_component module={component} id={"comp-#{row[:id]}-#{field}"} row={row} field={field} />
            <% else %>
            <%= if actions do %>
              <%= for action_fun <- actions do %>
                <%= action_fun.(row) %>
              <% end %>
            <% else %>
              <%= Map.get(row, field) %>
            <% end %>
            <% end %>
            <% end %>

          </td>
        <% end %>
      </tr>
    <% end %>
    <% end %>
    </tbody>

      </table>
    </div>
      <%= if @show_pagination do %>
        <div class="flex justify-between mt-4">
          <button phx-click="prev_page" phx-target={@myself} class="px-3 py-1 border rounded disabled:opacity-50" disabled={@page <= 1}>Anterior</button>
          <span class="self-center">Página <%= @page %></span>
          <button phx-click="next_page" phx-target={@myself} class="px-3 py-1 border rounded disabled:opacity-50" disabled={Enum.count(@rows) < @page_size}>Siguiente</button>
        </div>
      <% end %>
    </div>
    """
  end

  def handle_event("search", %{"search" => value}, socket) do
    socket =
      socket
      |> assign(:search, value)
      |> assign(:page, 1)
      |> update_paginated_rows()

    {:noreply, socket}
  end

  def handle_event("filter", %{} = params, socket) do
    socket =
      socket
      |> assign(:filters, params)
      |> assign(:page, 1)
      |> update_paginated_rows()

    {:noreply, socket}
  end

  def handle_event("sort", %{"field" => field}, socket) do
    field_atom = String.to_atom(field)

    new_order =
      case socket.assigns do
        %{sort_by: ^field_atom, sort_order: :asc} -> :desc
        _ -> :asc
      end

    socket =
      socket
      |> assign(:sort_by, field_atom)
      |> assign(:sort_order, new_order)
      |> assign(:page, 1)
      |> update_paginated_rows()

    {:noreply, socket}
  end

  def handle_event("prev_page", _, socket) do
    socket =
      socket
      |> update(:page, &max(&1 - 1, 1))
      |> update_paginated_rows()

    {:noreply, socket}
  end

  def handle_event("next_page", _, socket) do
    socket =
      socket
      |> update(:page, &(&1 + 1))
      |> update_paginated_rows()

    {:noreply, socket}
  end

  defp paginate(rows, page, page_size, search, sort_by, sort_order, filters) do
    rows
    |> filter_rows(search, filters)
    |> sort_rows(sort_by, sort_order)
    |> Enum.chunk_every(page_size)
    |> Enum.at(page - 1, [])
  end

  defp filter_rows(rows, "", filters), do: apply_filters(rows, filters)

  defp filter_rows(rows, search, filters) do
    rows
    |> Enum.filter(fn row ->
      Enum.any?(Map.values(row), fn value ->
        value && String.contains?(to_string(value), search)
      end)
    end)
    |> apply_filters(filters)
  end

  defp apply_filters(rows, filters) do
    Enum.reduce(filters, rows, fn
      {field, ""}, acc ->
        acc

      {field, value}, acc ->
        Enum.filter(acc, fn row ->
          to_string(Map.get(row, String.to_atom(field))) == value
        end)
    end)
  end

  defp sort_rows(rows, nil, _), do: rows
  defp sort_rows(rows, sort_by, :asc), do: Enum.sort_by(rows, &Map.get(&1, sort_by))
  defp sort_rows(rows, sort_by, :desc), do: Enum.sort_by(rows, &Map.get(&1, sort_by), :desc)

  defp get_label({_field, opts}) when is_binary(opts), do: opts
  defp get_label(opts) when is_list(opts), do: Keyword.get(opts, :label, "Sin título")
  defp get_label(_), do: "Sin título"

  defp get_sortable({_field, opts}) when is_binary(opts), do: true
  defp get_sortable(opts) when is_list(opts), do: Keyword.get(opts, :sortable, true)
  defp get_sortable(_), do: true

  defp get_renderer({_field, opts}) when is_binary(opts), do: nil
  defp get_renderer(opts) when is_list(opts), do: Keyword.get(opts, :render)
  defp get_renderer(_), do: nil

  defp get_component({_field, opts}) when is_list(opts), do: Keyword.get(opts, :component)
  defp get_component(opts) when is_list(opts), do: Keyword.get(opts, :component)
  defp get_component(_), do: nil

  defp get_th_class(opts, default) when is_list(opts), do: Keyword.get(opts, :th_class, default)
  defp get_th_class(_, default), do: default

  defp get_td_class(opts, default) when is_list(opts), do: Keyword.get(opts, :td_class, default)
  defp get_td_class(_, default), do: default

  defp get_filterable({_field, opts}) when is_list(opts),
    do: Keyword.get(opts, :filterable, false)

  defp get_filterable(_), do: false

  defp get_filter_options({_field, opts}) when is_list(opts), do: Keyword.get(opts, :options, [])
  defp get_filter_options(_), do: []

  defp get_actions({_field, opts}) when is_list(opts), do: Keyword.get(opts, :actions)
  defp get_actions(opts) when is_list(opts), do: Keyword.get(opts, :actions)
  defp get_actions(_), do: nil

  defp get_visible(opts) when is_list(opts), do: Keyword.get(opts, :visible, true)
  defp get_visible(_), do: true
end
