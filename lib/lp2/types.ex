defmodule LP2.Types do
  defmacro __using__(_opts) do
    quote do
      @type attribute_t :: {binary(), binary()}
      @type attribute_ts :: list(attribute_t())

      @type content_t :: binary() | quad_t()
      @type content_ts :: list(content_t)

      @type maybe(t) :: t | nil

      @type message_t :: {non_neg_integer(), severity_t(), binary()} 
      @type messages_t :: list(message_t)

      @type numbered_line_t :: {binary(), non_neg_integer()}

      @type input_t :: binary() | list(binary())

      @type quad_t :: {atom(), attribute_ts(), content_ts(), map()}
      @type quad_ts :: list(quad_t)

      @typep specific_quad_t(a) :: {a, attribute_ts(), content_ts(), map()}
      @type specific_quad_ts(a) :: list(specific_quad_t(a))

      @type quads_lead_by_t(a) :: [specific_quad_t(a)|quad_ts()]

      @type severity_t :: :error | :warning
      @type status_t :: :ok | :error | :warning

      @type result_t :: {status_t(), quad_ts(), messages_t()}
    end
  end
end
