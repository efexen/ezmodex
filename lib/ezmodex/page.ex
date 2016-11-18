defmodule Ezmodex.Page do

  defmacro __using__(opts) do
    quote do
      @status_code unquote(Keyword.get(opts, :status, 200))
      import Plug.Conn
      import unquote(__MODULE__)

      def init(opts), do: opts

      def set_data(conn), do: nil
      defoverridable [set_data: 1]
    end
  end

  defmacro partial(name, do: content) do
    quote do
      def unquote(name) do
        unquote(content)
      end
    end
  end

  defmacro data({ context_name, _, _ } \\ { :__context, nil, nil }, do: content) do
    context_var = Macro.var(context_name, nil)

    quote do
      def set_data(conn) do
        var!(unquote(context_var)) = clean_conn(conn)

        case Process.get(:view_data) do
          nil ->
            Process.put(:view_data, unquote(content))
          _ ->
            raise "Data already set"
        end
      end

      def data, do: Process.get(:view_data)
    end
  end

  defmacro view(do: content) do
    quote do

      def action(conn) do
        set_data(conn)

        conn
        |> put_resp_content_type("text/html")
        |> send_resp(@status_code, Enum.join(unquote(content), ""))
      end

    end
  end

  def clean_conn(conn) do
    %{
      connection: conn
    }
  end

end
