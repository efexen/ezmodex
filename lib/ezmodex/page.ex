defmodule Ezmodex.Page do

  defmacro __using__(opts) do
    quote do
      @status_code unquote(Keyword.get(opts, :status, 200))
      import Plug.Conn
      import unquote(__MODULE__)

      def init(opts), do: opts
    end
  end

  defmacro section(name, do: content) do
    quote do
      def unquote(name) do
        unquote(content)
      end
    end
  end

  defmacro view(do: content) do
    quote do
      def view(conn) do
        conn
        |> put_resp_content_type("text/html")
        |> send_resp(@status_code, Enum.join(unquote(content), ""))
      end
    end
  end

  def html5(children) do
    ["<!DOCTYPE html>", "<html>", children, "</html>"]
  end

end
