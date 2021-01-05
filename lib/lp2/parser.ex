defmodule LP2.Parser do
  use LP2.Types
  alias LP2.Scanner
  alias LP2.Parser.Context
  alias LP2.Parser.ListInfo

  import LP2.Parser.AstHelper

  @moduledoc false

  @typep li_only_t     :: specific_quad_ts(:li)

  @typep li_result_t   :: quads_lead_by_t(:li)
  @typep para_result_t :: quads_lead_by_t(:p)
  @typep ol_resolt_t   :: quads_lead_by_t(:ol)
  @typep ul_result_t   :: quads_lead_by_t(:ul)

  @typep list_result_t :: quads_lead_by_t(:ul) | quads_lead_by_t(:ol)

  @spec parse(input_t()) :: result_t()
  def parse(input) do
    input
    |> Scanner.scan_lines
    |> _parse([], struct(Context))
  end

  # _parse represents the new state of parsing we will
  # add a new block element to the result stack
  @spec _parse(Scanner.ts, quad_ts(), Context.t) :: result_t()
  defp _parse(input, result, context)
  defp _parse([%Scanner.Blank{}|rest], result, context) do
    _parse(rest, result, context)
  end
  defp _parse([%Scanner.Text{line: line}|rest], result, context) do
    _parse_para(rest, [raw_quad(:p, line)|result], context)
  end
  defp _parse([%Scanner.UlListItem{}=ul|rest], result, context) do
    _parse_ul(rest, _push_new_ul(ul, result), context, struct!(ListInfo, bullet: ul.bullet, list_indent: ul.list_indent))
  end
  defp _parse([], result, %Context{status: status, messages: messages}) do
    {status, Enum.reverse(result), messages}
  end

  @spec _parse_para(Scanner.ts, para_result_t(), Context.t) :: result_t()
  defp _parse_para([], result, context) do
    _parse([], _reverse_content_of_head(result), context)
  end
  defp _parse_para([%Scanner.Text{line: line}|rest], [para|result], context) do
    _parse_para(rest, [_push_to_content(line, para)|result], context)
  end
  defp _parse_para([%Scanner.Blank{}|rest], result, context) do
    _parse(rest, _reverse_content_of_head(result), context)
  end

  @spec _parse_ul(Scanner.ts, ul_result_t(), Context.t, ListInfo.t) :: result_t()
  defp _parse_ul([%Scanner.UlListItem{content: content}=li|rest], [ul|result], context, linfo) do
    linfo1 = ListInfo.update_loose(linfo)
    _parse_ul(rest, [_push_to_content({:li, [], [content], %{}}, ul)|result], context, linfo1)
  end
  defp _parse_ul([%Scanner.Blank{}|rest], result, context, %ListInfo{on_blank: true} = linfo) do
    result1 = _reverse_content_of_head(result)
    _parse(rest, _finalize_list(result1, linfo), context)
  end
  defp _parse_ul([%Scanner.Blank{}|rest], result, context, linfo) do
    _parse_ul(rest, result, context, %{linfo|on_blank: true})
  end
  defp _parse_ul(input, result, context, linfo) do
    result1 = _reverse_content_of_head(result)
    _parse(input, _finalize_list(result1, linfo), context)
  end

  @spec _finalize_list(list_result_t(), ListInfo.t) :: list_result_t()
  defp _finalize_list(result, li)
  defp _finalize_list(result, %ListInfo{loose: false}) do
    result
  end
  defp _finalize_list([{ltype, atts, content, meta}|result], %ListInfo{loose: true}) do
    [{ltype, atts, Enum.map(content, &make_list_item_loose/1), meta}|result]
  end

  @spec _reverse_content_of_head(quad_ts()) :: quad_ts()
  defp _reverse_content_of_head([{tag, atts, content, meta}|result]) do
    [{tag, atts, Enum.reverse(content), meta}|result]
  end

  @spec _push_new_ul(Scanner.UlListItem.t, quad_ts()) :: ul_result_t()
  defp _push_new_ul(%Scanner.UlListItem{content: content}, result) do
    ul = raw_quad(:ul, raw_quad(:li, content))
    [ul|result]
  end

  @spec _push_to_content(content_t(), quad_t()) :: quad_t()
  defp _push_to_content(new_content, {tag, atts, content, meta}) do
    {tag, atts, [new_content|content], meta}
  end

end
