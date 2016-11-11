defmodule Ezmodex.Mixfile do
  use Mix.Project

  def project do
    [app: :ezmodex,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:cowboy, :plug],
      mod: { Ezmodex, [] }
    ]
  end

  defp deps do
    [
      { :cowboy, "~> 1.0.0" },
      { :plug, "~> 1.0" },
      { :ex_doc, ">= 0.0.0", only: :dev }
    ]
  end

  defp description do
    """
    Ezmodex is a lightweight experimental Elixir microframework built on top of Plug
    """
  end

  defp package do
    [
      name: :ezmodex,
      maintainers: ["Ville Hellman"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/efexen/ezmodex"}
    ]
  end

end
