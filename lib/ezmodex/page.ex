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

  defmacro data(do: content) do
    quote do
      def set_data(conn), do: unquote(content)
      def data, do: nil
    end
  end

  defmacro view(do: content) do
    quote do
      def view(conn) do
        set_data(conn)

        conn
        |> put_resp_content_type("text/html")
        |> send_resp(@status_code, Enum.join(unquote(content), ""))
      end
    end
  end

end
