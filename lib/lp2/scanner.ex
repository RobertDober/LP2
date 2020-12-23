defmodule LP2.Scanner do
  @moduledoc false

  use LP2.Types
  use LP2.Scanner.Token

  token Blank
  token ListItem do
    field :type, type: :ul | :ol, default: :ul
    field :list_indent, type: non_neg_integer(), default: 0
  end

  @type t :: Blank.t | ListItem.t

  @spec scan_line(numbered_line_t()) :: ListItem.t()
  def scan_line(_line_lnb_tuple) do
    %ListItem{}
  end

end
