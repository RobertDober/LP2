defmodule LP2.Parser.ListInfo do
  use LP2.Types

  @enforce_keys [:bullet, :list_indent]
  defstruct bullet: nil, list_indent: nil, loose: false

  @type t :: %__MODULE__{bullet: binary(), list_indent: non_neg_integer(), loose: boolean()}

end
