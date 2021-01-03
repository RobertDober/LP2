defmodule LP2.Parser do
  use LP2.Types
  alias LP2.Scanner
  alias LP2.Parser.Context

  @moduledoc false

  @spec parse(input_t()) :: result_t()
  def parse(input) do
    input
    |> Scanner.scan_lines
    |> _parse([], struct(Context))
  end

  # _parse represents the new state of parsing we will
  # add a new block element to the result stack
  @spec _parse(Scanner.ts, qaud_ts(), Context.t) :: result_t()
  defp _parse(input, result, context)
  defp _parse([%Scanner.Blank{}|rest], result, context) do
    _parse(rest, result, context)
  end
  defp _parse([%Scanner.Text{line: line}|rest], result, context) do
    _parse_para(rest, [{"p", [], [line], %{}}|result], context)
  end
  defp _parse([%Scanner.UlListItem{}=ul|rest], result, context) do
    _parse_ul(rest, _push_new_ul(ul, result), context)
  end
  defp _parse([], result, %Context{status: status, messages: messages}) do
    {status, Enum.reverse(result), messages}
  end

  @spec _parse_para(Scanner.ts, qaud_ts(), Context.t) :: result_t()
  defp _parse_para([], result, context) do
    _parse([], _reverse_content_of_head(result), context)
  end
  defp _parse_para([%Scanner.Text{line: line}|rest], [{"p", atts, content, meta}|result], context) do
    _parse_para(rest, [{"p", atts, [line|content], meta}|result], context)
  end
  defp _parse_para([%Scanner.Blank{}|rest], result, context) do
    _parse(rest, _reverse_content_of_head(result), context)
  end

  defp _parse_ul(input, result, context) do
    _parse(input, result, context)
  end

  @spec _reverse_content_of_head(qaud_ts()) :: qaud_ts()
  defp _reverse_content_of_head([{tag, atts, content, meta}|result]) do
    [{tag, atts, Enum.reverse(content), meta}|result]
  end

  @spec _push_new_ul(Scanner.UlListItem.t, quad_ts()) :: quad_ts()
  defp _push_new_ul(%Scanner.UlListItem{content: content}, result) do
    [{"li", [], [content], %{}}, {"ul", [], [], %{}}|result]
  end

end
