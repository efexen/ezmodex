defmodule Ezmodex.Router do

  defmacro __using__(_opts) do
    quote do
      use Plug.Router
      import unquote(__MODULE__)

      plug :match
      plug :dispatch

    end
  end

  defmacro gets(definition, module) do
    quote do
      get unquote(definition) do
        unquote(module).view(var!(conn, Plug.Router))
      end
    end
  end

  defmacro not_found(module) do
    quote do
      match _ do
        unquote(module).view(var!(conn, Plug.Router))
      end
    end
  end

end
