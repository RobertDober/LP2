defmodule LP2.Parser.Context do
  use LP2.Types

  defstruct status: :ok,
            messages: []

  @type t :: %__MODULE__{status: status_t(), messages: messages_t()} 
  @type ts :: list(t())
end
