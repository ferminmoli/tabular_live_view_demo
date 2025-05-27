defmodule TabularDemoWeb.TableDemoLive do
  use TabularDemoWeb, :live_view

  def mount(_params, _session, socket) do
    columns = [
      name: [
        label: "Nombre",
        th_class: "bg-blue-100 text-blue-800",
        td_class: "font-semibold"
      ],
      email: [
        label: "Email",
        th_class: "bg-gray-100 text-gray-700",
        td_class: "text-sm"
      ],
      total: [
        label: "Total",
        sortable: true,
        th_class: "text-right",
        td_class: "text-right",
        render: fn row -> "$#{row.total}" end
      ]
    ]

    rows =
      Enum.map(1..40, fn i ->
        %{
          name: "Persona #{i}",
          email: "persona#{i}@correo.com",
          role: Enum.random(["User", "Admin", "Guest"]),
          total: Enum.random(100..999)
        }
      end)

    {:ok, assign(socket, columns: columns, rows: rows)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold mb-8">Tabular LiveView - Ejemplos</h1>

    <div class="space-y-10">

      <!-- Ejemplo 1 -->
      <section class="border p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-1">1. Tabla básica</h2>
        <p class="text-sm text-gray-600 mb-4">Incluye ordenamiento, búsqueda y paginación.</p>
        <.live_component
          module={TabularLiveView.TableComponentImported}
          id="example-1-basic"
          rows={@rows}
          columns={[
            name: "Nombre",
            email: "Email"
          ]}
        />
      </section>

      <!-- Ejemplo 2 -->
      <section class="border p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-1">2. Tabla sin buscador ni paginación</h2>
        <p class="text-sm text-gray-600 mb-4">Solo muestra los datos y permite ordenar.</p>
        <.live_component
          module={TabularLiveView.TableComponentImported}
          id="example-2-nosearch"
          rows={@rows}
          columns={[
            name: "Nombre",
            email: "Email"
          ]}
          opts={%{search: false, pagination: false}}
        />
      </section>

      <!-- Ejemplo 3 -->
      <section class="border p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-1">3. Tabla vacía con mensaje personalizado</h2>
        <p class="text-sm text-gray-600 mb-4">Se muestra cuando no hay resultados.</p>
        <.live_component
          module={TabularLiveView.TableComponentImported}
          id="example-3-empty"
          rows={[]}
          columns={[
            name: "Nombre",
            email: "Email"
          ]}
          opts={%{no_results_message: "Ups! No encontramos datos para mostrar."}}
        />
      </section>

      <!-- Ejemplo 4 -->
      <section class="border p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-1">4. Configuración avanzada</h2>
        <p class="text-sm text-gray-600 mb-4">Inicio en página 2, tamaño de página 5 y orden por email descendente.</p>
        <.live_component
          module={TabularLiveView.TableComponentImported}
          id="example-4-configurable"
          rows={@rows}
          columns={[
            name: [label: "Nombre", sortable: true],
            email: [label: "Correo electrónico", sortable: true],
            role: "Rol"
          ]}
          opts={%{
            page: 2,
            page_size: 5,
            sort_by: :email,
            sort_order: :desc
          }}
        />
      </section>

      <!-- Ejemplo 5 -->
      <section class="border p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-1">5. Con exportación CSV</h2>
        <p class="text-sm text-gray-600 mb-4">Agrega un botón para exportar los resultados.</p>
        <.live_component
          module={TabularLiveView.TableComponentImported}
          id="example-5-export"
          rows={@rows}
          columns={[
            name: [label: "Nombre", sortable: true],
            email: [label: "Correo electrónico", sortable: true],
            role: "Rol"
          ]}
          opts={%{
            export: true,
            sort_by: :email,
            sort_order: :desc,
            page: 1,
            page_size: 10
          }}
        />
      </section>

      <!-- Ejemplo 6 -->
      <section class="border p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-1">6. Estilos personalizados</h2>
        <p class="text-sm text-gray-600 mb-4">Personalización de estilos por columna y tabla.</p>
        <.live_component
          module={TabularLiveView.TableComponentImported}
          id="example-6-styled"
          rows={@rows}
          columns={[
            name: [
              label: "Nombre",
              sortable: true,
              th_class: "bg-blue-100 text-blue-900",
              td_class: "font-bold text-blue-800"
            ],
            email: [
              label: "Correo electrónico",
              th_class: "bg-green-100 text-green-800",
              td_class: "text-sm text-green-900"
            ],
            role: [
              label: "Rol",
              td_class: "italic text-right text-purple-800",
              th_class: "text-right bg-purple-100 text-purple-800"
            ]
          ]}
          opts={%{
            table_class: "w-full border border-blue-300 shadow-md",
            header_class: "px-4 py-2 text-left font-semibold",
            cell_class: "px-4 py-2 text-sm"
          }}
        />
      </section>
    </div>
    """
  end
end
