defmodule Ezmodex.HTML.SanitizerTest do
  use ExUnit.Case, async: true
  alias Ezmodex.HTML.Sanitizer
  doctest Sanitizer

  describe "clean/1" do

    test "it encodes ampersands" do
      assert result_contains?("ring &amp; It sha")
    end

    test "it encodes single quotes" do
      assert result_contains?("the &apos; char")
    end

    test "it encodes graves" do
      assert result_contains?("ers we&grave;ll ")
    end

    test "it encodes double quotes" do
      assert result_contains?("shall &quot; con")
    end

    test "it encodes less than sign" do
      assert result_contains?("is a &lt;test")
    end

    test "it encodes greater than sign" do
      assert result_contains?("care&gt; about")
    end

  end

  defp result_contains?(substring) do
    String.contains?(Sanitizer.clean(test_string), substring)
  end

  defp test_string do
    """
    This is a <test> string & It shall " contain all the ' characters we`ll <care> about
    """
  end

end
