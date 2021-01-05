defmodule LP2.Parser.ListInfo do
  use LP2.Types

  @enforce_keys [:bullet, :list_indent]
  defstruct bullet: nil, list_indent: nil, loose: false, on_blank: false

  @type t :: %__MODULE__{bullet: binary(), list_indent: non_neg_integer(), loose: boolean(), on_blank: boolean()}

  @spec update_loose(t()) :: t()
  def update_loose(linfo)
  def update_loose(%__MODULE__{loose: false, on_blank: true}=linfo) do
    %{linfo | loose: true, on_blank: false}
  end
  def update_loose(%__MODULE__{}=linfo) do
    %{linfo | on_blank: false}
  end
end
