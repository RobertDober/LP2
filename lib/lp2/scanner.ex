defmodule LP2.Scanner do
  @moduledoc false

  use LP2.Types
  use LP2.Scanner.Token

  token Blank
  token Indent do
    field :content, type: binary(), default: ""
    field :level, type: non_neg_integer(), default: 0
  end
  token OlListItem do
    field :bullet, type: binary(), default: "1"
    field :content, type: binary(), default: ""
    field :list_indent, type: non_neg_integer(), default: 0
  end
  token UlListItem do
    field :bullet, type: binary(), default: "-"
    field :content, type: binary(), default: ""
    field :list_indent, type: non_neg_integer(), default: 0
  end
  token Text do
    field :content, type: binary(), default: ""
  end

  @type t :: Blank.t | Indent.t | OlListItem | UlListItem.t | Text.t
  @type ts :: list(t())
  @type tokenfn_t :: ([binary()], numbered_line_t() -> t())

  @token_definitions [
    { ~r{\A(\s*)\z}, &__MODULE__.blank/2},
    { ~r[\A (\s{4,}) (.*) ]x, &__MODULE__.indent/2}, 
    { ~r{\A (\s*) ([-*+]) (\s+) (.*) }x, &__MODULE__.ul_item/2},
    { ~r<\A (\s*) (\d{1,9} [.)]) (\s+) (.*) >x, &__MODULE__.ol_item/2},
    { ~r{\A (\s*) (.*) }x, &__MODULE__.text/2},
  ]

  @nlrgx ~r{\n\r?}

  @spec scan_lines(input_t()) :: ts
  def scan_lines(lines)
  def scan_lines(lines) when is_binary(lines) do
    lines
    |> String.split(@nlrgx)
    |> scan_lines()
  end
  def scan_lines(lines) do
    lines
    |> Enum.zip(Stream.iterate(1, &(&1+1)))
    |> Enum.map(&scan_line/1)
  end

  @spec scan_line(numbered_line_t()) :: t()
  def scan_line(line_lnb_tuple)
  def scan_line({line, lnb}) do
    @token_definitions
    |> Enum.find_value(&match_token(&1, {line, lnb}))
  end

  @spec match_token({Regex.t, tokenfn_t}, numbered_line_t()) :: maybe(t())
  defp match_token(rgx_tokenfn_pair, line_lnb_pair)
  defp match_token({rgx, tokenfn}, {line, _}=nl) do
    case Regex.run(rgx, line) do
      nil -> nil
      m   -> tokenfn.(m, nl)
    end
  end

  @spec blank([binary()|[]], numbered_line_t()) :: Blank.t
  def blank(_, {line, lnb}) do
    _basic_token(Blank, {line, line, lnb})
  end

  @spec indent([binary()], numbered_line_t()) :: Indent.t
  def indent([_, leading_spaces, rest], {line, lnb}) do
    _basic_token(Indent, {leading_spaces, line, lnb}, content: rest)
  end
  
  @spec ol_item([binary()], numbered_line_t()) :: OlListItem.t
  def ol_item([_, leading_spaces, bullet, inbetween_spaces, rest], {line, lnb}) do
    indent = String.length(leading_spaces)
    bl = String.length(bullet) + String.length(inbetween_spaces)
    content = "#{String.slice(inbetween_spaces, 1..-1)}#{rest}"
    %OlListItem{line: line, lnb: lnb, bullet: bullet, content: content, indent: indent,
     list_indent: indent + bl}
  end

  @spec text([binary()], numbered_line_t()) :: Text.t
  def text([_, leading_spaces, content], {line, lnb}) do
    _basic_token(Text, {leading_spaces, line, lnb}, content: content)
  end

  @spec ul_item([binary()], numbered_line_t()) :: UlListItem.t
  def ul_item([_, leading_spaces, bullet, inbetween_spaces, rest], {line, lnb}) do
    indent = String.length(leading_spaces)
    bl = String.length(bullet) + String.length(inbetween_spaces)
    content = "#{String.slice(inbetween_spaces, 1..-1)}#{rest}"
    %UlListItem{line: line, lnb: lnb, bullet: bullet, content: content, indent: indent,
     list_indent: indent + bl}
  end

  @spec _basic_token(module(), {binary(), binary(), non_neg_integer()}, Keyword.t) :: t()
  defp _basic_token(token_type, {leading_spaces, line, lnb}, others \\ []) do
    token_type
    |> struct( Keyword.merge( [lnb: lnb, line: line, indent: String.length(leading_spaces)], others ) )
  end
end
