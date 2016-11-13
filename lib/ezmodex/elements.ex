defmodule Ezmodex.Elements do
  import Kernel, except: [div: 2]

  @empty_elements ~w(base link meta hr br wbr area img track embed object source col input menuitem)a

  @root_elements ~w(html)a
  @metadata_elements ~w(base head link meta style title)a
  @content_sectioning_elements ~w(body address article aside footer header h1 h2 h3 h4 h5 h6 hgroup nav section)a
  @text_content_elements ~w(dd del div dl dt figcaption figure hr ins li main ol p pre ul)a
  @inline_text_elements ~w(a abbr b bdi bdo br cite code dfn em i kbd mark q rp rt rtc ruby s samp small span strong sub sup time u var wbr)a
  @multimedia_elements ~w(area audio img map track video)a
  @embedded_elements ~w(embed object param source)a
  @scripting_elements ~w(canvas noscript script)a
  @table_elements ~w(caption col colgroup table tbody td tfoot th thead tr)a
  @form_elements ~w(button datalist fieldset form input label legend meter optgroup option output progress select textarea)a
  @interactive_elements ~w(details dialog menu menuitem summary)a
  @web_component_elements ~w(content element shadow template)a

  @all_elements @root_elements ++ @metadata_elements ++ @content_sectioning_elements ++ @text_content_elements ++ @inline_text_elements ++
    @multimedia_elements ++ @embedded_elements ++ @scripting_elements ++ @table_elements ++ @form_elements ++ @interactive_elements ++ @web_component_elements

  @moduledoc """
  Provides functions to create HTML element trees and its nodes such as html5 doctype and safe text

  ### Elements

  Following HTML elements are currently supported

  `#{ Enum.join(@all_elements, "` `") }`

  Each element accepts 2 optional parameters, a map of attributes and a list of child elements

  The result of calling the element functions is a list that can be collapsed to a HTML string

  #### Uncollapsed example

      iex> ul [ li [ text("Tom & Jerry") ] ]
      ["<ul>", "<li>", "Tom &amp; Jerry", "</li>", "</ul">]

      iex> Enum.join(ul [ li [ text("Tom & Jerry") ] ], "")
      "<ul><li>Tom &amp; Jerry</li></ul>"

  **All following examples below will only show the collapsed version**

  #### Element Examples

      iex> html
      "<html></html>"

      iex> p(%{ class: "stuff" })
      "<p class=\"stuff\"></p>"

      iex> ul [ li [ text("Item") ]
      "<ul><li>Item</li></ul>"

      iex> a %{ href: "https://google.com" }, [ text("Google") ]
      "<a href="https://google.com">Google</a>"

  The following empty elements will not render a closing tag and will discard any child elements

  `#{ Enum.join(@empty_elements, "` `") }`

  #### Empty Element Examples

      iex> img
      "<img>"

      iex> link %{ rel: "stylesheet", href: "styles.css" }
      "<link rel="stylesheet" href="styles.css">"

      iex> hr [ div ]
      "<hr>"

  """

  defmacro __using__(options) do
    quote do
      import Kernel, except: [div: 2]
      import Ezmodex.Elements, unquote(options)
    end
  end

  @doc """
  Convenience function that will create a html5 doctype and wrap all children in <html> and </html> tags. Should be used as the root element of the view section.

  ### Example

      iex> html5 [ head, body ]
      "<!DOCTYPE html><html><head></head><body</body></html>"

  """
  def html5(children) do
    ["<!DOCTYPE html>", html([ children ])]
  end

  Enum.each(@all_elements, fn name ->
    @doc false
    def unquote(name)(), do: unquote(name)(%{}, [])
    @doc false
    def unquote(name)(attributes) when is_map(attributes), do: unquote(name)(attributes, [])
    @doc false
    def unquote(name)(children) when is_list(children), do: unquote(name)(%{}, children)
    @doc false
    def unquote(name)(attributes, children) do
      build_element(unquote(name), attributes, children)
    end
  end)

  @doc"""
  Safely inserts a string of text to the element tree. Uses the Ezmodex.HTML.Sanitizer to escape special characters

  ### Examples

      iex> text("Helloo")
      "Helloo"

      iex> text("<script>")
      "&lt;script&gt;"

  """
  @spec text(String.t) :: String.t
  def text(string) do
    [Ezmodex.HTML.Sanitizer.clean(string)]
  end

  @doc"""
  Creates a HTML tag out of the string passed in as first argument.

  Accepts map of attributes as second argument and a list of children as third.

  Allows creation of custom elements not supported as standard.

  ### Examples

      iex> build_element("bunny", %{ awesomeness: "high" }, [])
      "<bunny awesomeness="high"></bunny>"

  """
  @spec build_element(String.t, map, list) :: List.t
  def build_element(element, attributes, children) do
    element_name = Atom.to_string(element)

    start_element = ["<#{element_name}#{format_attributes(attributes)}>"]

    if empty_element?(element) do
      start_element
    else
      start_element ++ [children, "</#{element_name}>"]
    end
  end

  defp empty_element?(element) do
    @empty_elements |> Enum.member?(element)
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
