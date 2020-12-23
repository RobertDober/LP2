defmodule LP2.Types do
  defmacro __using__(_opts) do
    quote do
      @type numbered_line_t :: {binary(), non_neg_integer()}
    end
  end
end
