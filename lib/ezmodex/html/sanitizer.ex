defmodule Ezmodex.HTML.Sanitizer do
  import String, only: [replace: 3]

  @moduledoc """
  Provides functions to sanitize HTML
  """

  @doc """
  Replaces instances of & \' \" < > and grave tick with HMTL entity names

  ## Examples

      iex> Ezmodex.HTML.Sanitizer.clean("<test>")
      "&lt;test&gt;"

      iex> Ezmodex.HTML.Sanitizer.clean("Tom & Jerry")
      "Tom &amp; Jerry"

  """
  def clean(""), do: ""
  def clean(string) do
    string
    |> replace("&", "&amp;")
    |> replace("'", "&apos;")
    |> replace("`", "&grave;")
    |> replace("\"", "&quot;")
    |> replace("<", "&lt;")
    |> replace(">", "&gt;")
  end

end
