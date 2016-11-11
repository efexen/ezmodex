defmodule Ezmodex.NotFound do
  use Ezmodex.Page, status: 404
  use Ezmodex.Elements

  view do
    html5 [
      text("Not Found")
    ]
  end

end
