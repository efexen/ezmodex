defmodule Ezmodex.Elements do
  import Kernel, except: [div: 2]

  @all_elements MapSet.new(
    ~w(html head body title p div h1 h2 a ul li input)a
  )

  defmacro __using__(options) do
    quote do
      import Kernel, except: [div: 2]
      import Ezmodex.Elements, unquote(options)
    end
  end

  def html5(children) do
    ["<!DOCTYPE html>", html([ children ])]
  end

  Enum.each(@all_elements, fn name ->
    def unquote(name)(attributes) when is_map(attributes), do: unquote(name)(attributes, [])
    def unquote(name)(children) when is_list(children), do: unquote(name)(%{}, children)
    def unquote(name)(attributes, children) do
      build_tag(unquote(name), attributes, children)
    end
  end)

  def text(string) do
    [Ezmodex.HTML.Sanitizer.clean(string)]
  end

  defp build_tag(tag, attributes, children) do
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

end
