# Ezmodex

Highly experimental lightweight microframework built on top of Plug

## Installation

  1. Add `ezmodex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ezmodex, "~> 0.4.0"}]
    end
    ```

  2. Ensure `ezmodex` is started before your application:

    ```elixir
    def application do
      [applications: [:ezmodex]]
    end
    ```
  3. Set the ezmodex configuration in your `config.exs`:

    ```elixir
    config :ezmodex,
      router: Demo.Router,
      port: 1337
    ```

  4. Create a router file:

    ```elixir
    defmodule Demo.Router do
      use Ezmodex.Router

      gets "/", Demo.Homepage

      not_found Ezmodex.NotFound

    end
    ```

  5. Create your page:

    ```elixir
    defmodule Demo.Homepage do
      use Ezmodex.Page
      use Ezmodex.Elements

      view do
        html5 [
          head,
          body
        ]
      end

      partial head do
        head [
          title [ text("Homepage") ]
        ]
      end

      partial body do
        body [
          div [
            h1([ text("Ezmodex!") ]),
            p [
              text("More info at: "),
              a(%{ href: "http://github.com/efexen/ezmodex" }, [
                text("Ezmodex Github")
              ])
            ]
          ]
        ]
      end
    end
    ```

  6. Start your app and PROFIT!

### Everything is WIP
