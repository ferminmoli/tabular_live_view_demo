defmodule TabularDemoWeb.TableDemoLive do
  use TabularDemoWeb, :live_view

  alias TabularDemoWeb.Components.RoleBadgeComponent

  def mount(_params, _session, socket) do
    rows =
      Enum.map(1..40, fn i ->
        %{
          id: i,
          name: "Person #{i}",
          email: "person#{i}@mail.com",
          role: Enum.random(["User", "Admin", "Guest"]),
          total: Enum.random(100..999)
        }
      end)

    {:ok, assign(socket, rows: rows)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold mb-8">Tabular LiveView – Examples</h1>

    <div class="space-y-10">
      <!-- Example 1: Basic -->
      <section class="border p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-1">1. Basic Table</h2>
        <p class="text-sm text-gray-600 mb-4">Includes sorting, search, and pagination.</p>
        <.live_component
          module={TabularLiveView.TableComponentImported}
          id="example-1-basic"
          rows={@rows}
          rows={@rows}
          columns={
          [
            name: [label: "Name"],
            email: [label: "Email"],
            role: [label: "Role"]
          ]
          }
        />
      </section>

      <!-- Example 2: No Search or Pagination -->
      <section class="border p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-1">2. No Search or Pagination</h2>
        <p class="text-sm text-gray-600 mb-4">Displays data only with sorting enabled.</p>
        <.live_component
          module={TabularLiveView.TableComponentImported}
          id="example-2-nosearch"
          rows={@rows}
          columns={[name: "Name", email: "Email"]}
          opts={%{search: false, pagination: false}}
        />
      </section>

      <!-- Example 3: Empty Table with Custom Message -->
      <section class="border p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-1">3. Empty Table with Custom Message</h2>
        <p class="text-sm text-gray-600 mb-4">Displays a message when there are no results.</p>
        <.live_component
          module={TabularLiveView.TableComponentImported}
          id="example-3-empty"
          rows={[]}
          columns={[name: [label: "Name"], email: [label: "Email"], role: [label: "Role"]]}
          opts={%{no_results_message: "Oops! No data found."}}
        />
      </section>

      <!-- Example 4: Advanced Configuration -->
      <section class="border p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-1">4. Advanced Configuration</h2>
        <p class="text-sm text-gray-600 mb-4">Starts on page 2, page size of 5, sorted by email descending.</p>
        <.live_component
          module={TabularLiveView.TableComponentImported}
          id="example-4-configurable"
          rows={@rows}
          columns={
            [name: [label: "Name", sortable: true],
            email: [label: "Email", sortable: true],
            role: "Role"]
          }
          opts={%{page: 2, page_size: 5, sort_by: :email, sort_order: :desc}}
        />
      </section>

      <!-- Example 5: CSV Export -->
      <section class="border p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-1">5. CSV Export</h2>
        <p class="text-sm text-gray-600 mb-4">Adds a button to export the results.</p>
        <.live_component
          module={TabularLiveView.TableComponentImported}
          id="example-5-export"
          rows={@rows}
          columns={
           [ name: [label: "Name", sortable: true],
            email: [label: "Email", sortable: true],
            role: "Role"]
          }
          opts={%{export: true, sort_by: :email, sort_order: :desc, page: 1, page_size: 10}}
        />
      </section>

      <!-- Example 6: Custom Styling -->
      <section class="border p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-1">6. Custom Styling</h2>
        <p class="text-sm text-gray-600 mb-4">Custom styles per column and table using Tailwind CSS.</p>
        <.live_component
          module={TabularLiveView.TableComponentImported}
          id="example-6-styled"
          rows={@rows}
          columns={
            [name: [label: "Name", sortable: true, th_class: "bg-blue-100 text-blue-900", td_class: "font-bold text-blue-800"],
            email: [label: "Email", th_class: "bg-green-100 text-green-800", td_class: "text-sm text-green-900"],
            role: [label: "Role", th_class: "text-right bg-purple-100 text-purple-800", td_class: "italic text-right text-purple-800"]]
          }
          opts={%{
            table_class: "w-full border border-blue-300 shadow-md",
            header_class: "px-4 py-2 text-left font-semibold",
            cell_class: "px-4 py-2 text-sm"
          }}
        />
      </section>

      <!-- Example 7: Component in Cell -->
      <section class="border p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-1">7. Component in Cell</h2>
        <p class="text-sm text-gray-600 mb-4">Renders a custom LiveComponent (badge) inside the Role column.</p>
        <.live_component
          module={TabularLiveView.TableComponentImported}
          id="example-7-component-cell"
          rows={@rows}
          columns={
            [name: [label: "Name"],
            email: [label: "Email"],
            role: [label: "Role", component: RoleBadgeComponent]]
          }
        />
      </section>


    <!-- Example 9: Row Actions -->
    <section class="border p-4 rounded shadow">
    <h2 class="text-xl font-semibold mb-1">9. Row Actions</h2>
    <p class="text-sm text-gray-600 mb-4">Includes Edit and Delete actions per row.</p>
    <.live_component
      module={TabularLiveView.TableComponentImported}
      id="example-9-row-actions"
      rows={@rows}
      columns={[
        actions: [label: "Actions", actions: [&edit_action/1, &delete_action/1]],
        name: [label: "Name"],
        email: [label: "Email"]
      ]}
      />
      </section>

    <!-- Example 8: Column Visibility -->
    <section class="border p-4 rounded shadow">
    <h2 class="text-xl font-semibold mb-1">8. Hidden Column</h2>
    <p class="text-sm text-gray-600 mb-4">Email column is hidden using <code>visible: false</code>.</p>
    <.live_component
    module={TabularLiveView.TableComponentImported}
    id="example-8-hidden"
    rows={@rows}
    columns={[
      name: [label: "Name"],
      email: [label: "Email", visible: false],
      role: [label: "Role"]
    ]}
    />
    </section>
    <!-- Example 10: Scroll X -->
    <section class="border p-4 rounded shadow">
    <h2 class="text-xl font-semibold mb-1">10. Horizontal Scroll</h2>
    <p class="text-sm text-gray-600 mb-4">Horizontal scroll for wide tables with many columns.</p>
    <.live_component
    module={TabularLiveView.TableComponentImported}
    id="example-10-scroll"
    rows={
      Enum.map(1..30, fn i ->
        Enum.reduce(1..15, %{id: i}, fn j, acc ->
          Map.put(acc, :"col_#{j}", "Data #{i}/#{j}")
        end)
      end)
    }
    columns={
      Enum.map(1..15, fn j ->
        {:"col_#{j}", [label: "Column #{j}"]}
      end)
    }
    opts={%{scroll_x: true}}
    />
    </section>

    <!-- Example 11: Sticky Header + Scroll -->
    <!-- Example 11: Sticky Header + Scroll -->
    <section class="border p-4 rounded shadow">
    <h2 class="text-xl font-semibold mb-1">11. Sticky Header & Scroll</h2>
    <p class="text-sm text-gray-600 mb-4">Sticky header + scroll for better UX in large datasets.</p>
    <.live_component
    module={TabularLiveView.TableComponentImported}
    id="example-11-sticky-scroll"
    rows={
      Enum.map(1..50, fn i ->
        Enum.reduce(1..12, %{id: i}, fn j, acc ->
          Map.put(acc, :"col_#{j}", "Item #{i}:#{j}")
        end)
      end)
    }
    columns={
      Enum.map(1..12, fn j ->
        {:"col_#{j}", [label: "Column #{j}"]}
      end)
    }
    opts={%{scroll_x: true, sticky_header: true}}
    />
    </section>


    </div>
    """
  end

  def edit_action(row) do
    assigns = %{id: row.id}

    ~H"""
    <button href={"#"} phx-click="edit" phx-value-id={@id} class="text-blue-600 hover:underline mr-2" title="Edit">✏️</button>
    """
  end

  def delete_action(row) do
    assigns = %{id: row.id}

    ~H"""
    <button href={"#"} phx-click="delete" phx-value-id={@id} class="text-red-600 hover:underline" title="Delete">🗑️</button>
    """
  end

  def handle_event("edit", %{"id" => id}, socket) do
    {:noreply, put_flash(socket, :info, "Editing row with ID: #{id}")}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    {:noreply, put_flash(socket, :info, "Deleting row with ID: #{id}")}
  end
end
