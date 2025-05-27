# Tabular LiveView Demo

This is the official demo project for [Tabular LiveView](https://github.com/ferminmoli/tabular_live_view), showcasing its core features in a Phoenix LiveView app.

## Features

- ✅ Basic table with pagination, search, and sorting
- 🔠 Sortable and configurable columns
- 🎨 Tailwind-based styling per table and per column
- 📄 Export to CSV
- 💬 Custom "no results" messages

## Running the demo

```bash
cd tabular_demo
mix deps.get
mix phx.server
```

```elixir
<.live_component
  module={TabularLiveView.TableComponent}
  id="users"
  rows={@rows}
  columns={[
    name: [label: "Name", sortable: true],
    email: [label: "Email"],
    role: [label: "Role", filterable: true, options: ["Admin", "User", "Guest"]]
  ]}
  opts={%{
    pagination: true,
    export: true,
    table_class: "border w-full",
    header_class: "text-gray-600 bg-gray-50",
    cell_class: "px-3 py-2"
  }}
/>
```

MIT © Fermín Molinuevo