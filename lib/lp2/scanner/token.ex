defmodule LP2.Scanner.Token do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__), only: [token: 1, token: 2]
    end
  end

  defmacro token(token_name, opts \\ [])
  defmacro token(token_name, do: block)do
    _token(token_name, block)
  end
  defmacro token(token_name, _) do
    _token(token_name, do: [])
  end

  defp _token(token_name, block)
  defp _token(token_name, nil) do
    quote do
      defmodule unquote(token_name) do
        defstruct line: "", lnb: 0, indent: 0 
      end
    end
  end
  defp _token(token_name, blk) do
    quote do
      defmodule unquote(token_name) do
        Module.eval_quoted(
        __ENV__,
        unquote(__MODULE__).token_with_fields(unquote(Macro.escape(blk))))
      end
    end
  end

  @doc false
  def token_with_fields(blk) do
    quote do
      import LP2.Scanner.Token, only: [field: 2]
      Module.register_attribute(__MODULE__, :fields, accumulate: true)
      Module.register_attribute(__MODULE__, :struct_types, accumulate: true)
      field :line, type: binary(), default: ""
      field :lnb, type: non_neg_integer(), default: 0
      field :indent, type: non_neg_integer(), default: 0
      (fn ->
        unquote(blk)
      end).()
        defstruct @fields
        unquote(__MODULE__).define_type(@struct_types)
    end
  end

  @doc """
  coming soon,...

      for large values of soon
  """
  defmacro field(name, opts \\ [])
  defmacro field(name, opts) do
    default = Keyword.get(opts, :default, nil)
    type    = Keyword.get(opts, :type)
    quote do
      Module.put_attribute(__MODULE__, :fields, {unquote(name), unquote(default)})
      Module.put_attribute(__MODULE__, :struct_types, {unquote(name), unquote(Macro.escape(type))})
    end
  end

  @doc false
  defmacro define_type(types) do
    quote bind_quoted: [types: types] do
      @type t() :: %__MODULE__{unquote_splicing(types)}
    end
  end

end
