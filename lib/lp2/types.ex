defmodule LP2.Types do
  defmacro __using__(_opts) do
    quote do
      @type attribute_t :: {binary(), binary()}
      @type attribute_ts :: list(attribute_t())

      @type maybe(t) :: t | nil

      @type message_t :: {non_neg_integer(), severity_t(), binary()} 
      @type messages_t :: list(message_t)

      @type numbered_line_t :: {binary(), non_neg_integer()}

      @type input_t :: binary() | list(binary())

      @type qaud_t :: {binary(), attribute_ts(), qaud_ts(), map()}
      @type qaud_ts :: list(qaud_t)

      @type severity_t :: :error | :warning
      @type status_t :: :ok | :error | :warning

      @type result_t :: {status_t(), qaud_ts(), messages_t()}
    end
  end
end
