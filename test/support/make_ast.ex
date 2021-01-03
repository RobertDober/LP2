defmodule Test.Support.MakeAst do
  @moduledoc false
  defmacro __using__(_opts \\ []) do
    quote do
      import unquote(__MODULE__)
      @moduletag :meta
    end
  end

  def p(content, atts \\ []), do: make_tag(:p, content, atts)
  def li(content, atts \\ []), do: make_tag(:li, content, atts)
  def ol(content, atts \\ []), do: make_tag(:ol, content, atts)
  def ul(content, atts \\ []), do: make_tag(:ul, content, atts)

  def ok(content) when is_list(content), do: {:ok, content, []}
  def ok(content), do: {:ok, [content], []}


  def make_tag(tag, content, atts \\ [])
  def make_tag(tag, content, atts) when is_binary(content) or is_tuple(content) do
    _make_tag(tag, atts, [content], %{})
  end
  def make_tag(tag, content, atts) do
    _make_tag(tag, atts, content, %{})
  end

  defp _convert_att({key, value}), do: {to_string(key), to_string(value)}

  defp _convert_atts(atts) do
    Enum.map(atts, &_convert_att/1)
  end

  defp _make_tag(tag, atts, content, meta), do: {tag, _convert_atts(atts), content, meta}

end
