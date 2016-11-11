defmodule Ezmodex.Elements do

  @all_elements MapSet.new(
    ~w(head body title p div h1 h2 a ul li input)a
  )

  defmacro __using__(options) do
    elements = import_elements(options)

    quote bind_quoted: [elements: elements] do
      import Kernel, except: [div: 2]
      import Ezmodex.Elements

      Enum.each(elements, fn name ->
        def unquote(name)(attributes) when is_map(attributes), do: unquote(name)(attributes, [])
        def unquote(name)(children) when is_list(children), do: unquote(name)(%{}, children)
        def unquote(name)(attributes, children) when is_map(attributes) and is_list(children) do
          build_tag(unquote(name), attributes, children)
        end
      end)

    end
  end

  def text(string), do: [string]

  def build_tag(tag, attributes, children) do
    tag_name = Atom.to_string(tag)

    start_tag = ["<#{tag_name}#{format_attributes(attributes)}>"]

    if childless_tag?(tag) do
      start_tag
    else
      start_tag ++ [children, "</#{tag_name}>"]
    end
  end

  defp childless_tag?(tag) do
    ~w(input)a |> Enum.member?(tag)
  end

  defp format_attributes(attributes) do
    attributes
    |> Enum.map(&format_attribute/1)
    |> Enum.join("")
  end

  defp format_attribute({}), do: ""
  defp format_attribute({ name, value }) do
    " #{name}=\"#{value}\""
  end

  defp import_elements(options) do
    cond do
      Keyword.has_key?(options, :only) ->
        MapSet.intersection(@all_elements, MapSet.new(options[:only]))
      Keyword.has_key?(options, :except) ->
        MapSet.difference(@all_elements, MapSet.new(options[:except]))
      true ->
        @all_elements
    end |> MapSet.to_list
  end

end
