defmodule Test.LP2.ScannerTest do
  use ExUnit.Case
  alias LP2.Scanner

  @all_but_leading_ws ~r{\S.*}
  [
    { "",         %Scanner.Blank{} },
    { "        ", %Scanner.Blank{} },

    # { "<!-- comment -->", %Scanner.HtmlComment{complete: true} },
    # { "<!-- comment",     %Scanner.HtmlComment{complete: false} },

    { "- -",   %Scanner.UlListItem{bullet: "-", content: "-", list_indent: 2} },
    # { "- - -", %Scanner.Ruler{type: "-"} },
    # { "--",    %Scanner.SetextUnderlineHeading{level: 2} },
    # { "---",   %Scanner.Ruler{type: "-"} },

    { "* *",   %Scanner.UlListItem{bullet: "*", content: "*", list_indent: 2} },
    # { "* * *", %Scanner.Ruler{type: "*"} },
    { "**",    %Scanner.Text{content: "**", line: "**"} },
    # { "***",   %Scanner.Ruler{type: "*"} },

    { "_ _",   %Scanner.Text{content: "_ _"} },
    # { "_ _ _", %Scanner.Ruler{type: "_"} },
    { "__",    %Scanner.Text{content: "__"} },
    # { "___",   %Scanner.Ruler{type: "_"} },

    # { "# H1",       %Scanner.Heading{level: 1, content: "H1"} },
    # { "## H2",      %Scanner.Heading{level: 2, content: "H2"} },
    # { "### H3",     %Scanner.Heading{level: 3, content: "H3"} },
    # { "#### H4",    %Scanner.Heading{level: 4, content: "H4"} },
    # { "##### H5",   %Scanner.Heading{level: 5, content: "H5"} },
    # { "###### H6",  %Scanner.Heading{level: 6, content: "H6"} },
    # { "####### H7", %Scanner.Text{content: "####### H7"} },

    # { "> quote",    %Scanner.BlockQuote{content: "quote"} },
    # { ">    quote", %Scanner.BlockQuote{content: "   quote"} },
    # { ">quote",     %Scanner.BlockQuote{content: "quote"} },
    # { " >  quote",     %Scanner.BlockQuote{content: " quote"} },
    # { " >", %Scanner.BlockQuote{content: ""}},

    #1234567890123
    { "   a",         %Scanner.Text{content: "a", line: "   a"} },
    { "    b",        %Scanner.Indent{content: "b"} },
    { "      c",      %Scanner.Indent{content: "c"} },
    { "        d",    %Scanner.Indent{content: "d"} },
    { "          e",  %Scanner.Indent{content: "e"} },
    { "    - f",      %Scanner.Indent{content: "- f"} },
    { "     *  g",    %Scanner.Indent{content: "*  g"} },
    { "      012) h", %Scanner.Indent{content: "012) h"} },

    # { "```",      %Scanner.Fence{delimiter: "```", language: "",     line: "```"} },
    # { "``` java", %Scanner.Fence{delimiter: "```", language: "java", line: "``` java"} },
    # { " ``` java", %Scanner.Fence{delimiter: "```", language: "java", line: " ``` java"} },
    # { "```java",  %Scanner.Fence{delimiter: "```", language: "java", line: "```java"} },
    # { "```language-java",  %Scanner.Fence{delimiter: "```", language: "language-java"} },
    # { "```language-élixir",  %Scanner.Fence{delimiter: "```", language: "language-élixir"} },
    # { "   `````",  %Scanner.Fence{delimiter: "`````", language: "", line: "   `````"} },

    # { "~~~",      %Scanner.Fence{delimiter: "~~~", language: "",     line: "~~~"} },
    # { "~~~ java", %Scanner.Fence{delimiter: "~~~", language: "java", line: "~~~ java"} },
    # { "  ~~~java",  %Scanner.Fence{delimiter: "~~~", language: "java", line: "  ~~~java"} },
    # { "~~~ language-java", %Scanner.Fence{delimiter: "~~~", language: "language-java"} },
    # { "~~~ language-élixir",  %Scanner.Fence{delimiter: "~~~", language: "language-élixir"} },
    # { "~~~~ language-élixir",  %Scanner.Fence{delimiter: "~~~~", language: "language-élixir"} },

    { "``` hello ```", %Scanner.Text{content: "``` hello ```"} },
    { "```hello```", %Scanner.Text{content: "```hello```"} },
    { "```hello world", %Scanner.Text{content: "```hello world"} },

    # { "<pre>",             %Scanner.HtmlOpenTag{tag: "pre", content: "<pre>"} },
    # { "<pre class='123'>", %Scanner.HtmlOpenTag{tag: "pre", content: "<pre class='123'>"} },
    # { "</pre>",            %Scanner.HtmlCloseTag{tag: "pre"} },
    # { "   </pre>",            %Scanner.HtmlCloseTag{indent: 3, tag: "pre"} },

    # { "<pre>a</pre>",      %Scanner.HtmlOneLine{tag: "pre", content: "<pre>a</pre>"} },

    # { "<area>",              %Scanner.HtmlOneLine{tag: "area", content: "<area>"} },
    # { "<area/>",             %Scanner.HtmlOneLine{tag: "area", content: "<area/>"} },
    # { "<area class='a'>",    %Scanner.HtmlOneLine{tag: "area", content: "<area class='a'>"} },

    # { "<br>",              %Scanner.HtmlOneLine{tag: "br", content: "<br>"} },
    # { "<br/>",             %Scanner.HtmlOneLine{tag: "br", content: "<br/>"} },
    # { "<br class='a'>",    %Scanner.HtmlOneLine{tag: "br", content: "<br class='a'>"} },

    # { "<hr />",              %Scanner.HtmlOneLine{tag: "hr", content: "<hr />"} },
    # { "<hr/>",             %Scanner.HtmlOneLine{tag: "hr", content: "<hr/>"} },
    # { "<hr class='a'>",    %Scanner.HtmlOneLine{tag: "hr", content: "<hr class='a'>"} },

    # { "<img>",              %Scanner.HtmlOneLine{tag: "img", content: "<img>"} },
    # { "<img/>",             %Scanner.HtmlOneLine{tag: "img", content: "<img/>"} },
    # { "<img class='a'>",    %Scanner.HtmlOneLine{tag: "img", content: "<img class='a'>"} },

    # { "<wbr>",              %Scanner.HtmlOneLine{tag: "wbr", content: "<wbr>"} },
    # { "<wbr/>",             %Scanner.HtmlOneLine{tag: "wbr", content: "<wbr/>"} },
    # { "<wbr class='a'>",    %Scanner.HtmlOneLine{tag: "wbr", content: "<wbr class='a'>"} },

    # { "<h2>Headline</h2>",               %Scanner.HtmlOneLine{tag: "h2", content: "<h2>Headline</h2>"} },
    # { "<h2 id='headline'>Headline</h2>", %Scanner.HtmlOneLine{tag: "h2", content: "<h2 id='headline'>Headline</h2>"} },

    # { "<h3>Headline",               %Scanner.HtmlOpenTag{tag: "h3", content: "<h3>Headline"} },

    # { id1, %Scanner.IdDef{id: "ID1", url: "http://example.com", title: "The title"} },
    # { id2, %Scanner.IdDef{id: "ID2", url: "http://example.com", title: "The title"} },
    # { id3, %Scanner.IdDef{id: "ID3", url: "http://example.com", title: "The title"} },
    # { id4, %Scanner.IdDef{id: "ID4", url: "http://example.com", title: ""} },
    # { id5, %Scanner.IdDef{id: "ID5", url: "http://example.com", title: "The title"} },
    # { id6, %Scanner.IdDef{id: "ID6", url: "http://example.com", title: "The title"} },
    # { id7, %Scanner.IdDef{id: "ID7", url: "http://example.com", title: "The title"} },
    # { id8, %Scanner.IdDef{id: "ID8", url: "http://example.com", title: "The title"} },
    # { id9, %Scanner.Indent{content: "[ID9]: http://example.com  \"The title\"",
    #     level: 1,       line: "    [ID9]: http://example.com  \"The title\""} },

    #   {id10, %Scanner.IdDef{id: "ID10", url: "/url/", title: "Title with \"quotes\" inside"}},
    #   {id11, %Scanner.IdDef{id: "ID11", url: "http://example.com", title: "Title with trailing whitespace"}},
    #   {id12, %Scanner.IdDef{id: "ID12", url: "]hello", title: ""}},


      { "* ul1", %Scanner.UlListItem{ bullet: "*", content: "ul1", list_indent: 2} },
      { "+ ul2", %Scanner.UlListItem{ bullet: "+", content: "ul2", list_indent: 2} },
      { "- ul3", %Scanner.UlListItem{ bullet: "-", content: "ul3", list_indent: 2} },

      { "*     ul4", %Scanner.UlListItem{ bullet: "*", content: "    ul4", list_indent: 6} },
      { "*ul5",      %Scanner.Text{content: "*ul5"} },

      { "1. ol1",          %Scanner.OlListItem{ bullet: "1.", content: "ol1", list_indent: 3} },
      { "12345.      ol2", %Scanner.OlListItem{ bullet: "12345.", content: "     ol2", list_indent: 12} },
      { "12345)      ol3", %Scanner.OlListItem{ bullet: "12345)", content: "     ol3", list_indent: 12} },

      { "1234567890. ol4", %Scanner.Text{ content: "1234567890. ol4"} },
      { "1.ol5", %Scanner.Text{ content: "1.ol5"} },

      # { "=",        %Scanner.SetextUnderlineHeading{level: 1} },
      # { "========", %Scanner.SetextUnderlineHeading{level: 1} },
      # { "-",        %Scanner.SetextUnderlineHeading{level: 2} },
      # { "= and so", %Scanner.Text{content: "= and so"} },

      { "   (title)", %Scanner.Text{content: "(title)", line: "   (title)"} },

      # { "{: .attr }",       %Scanner.Ial{attrs: ".attr", verbatim: " .attr "} },
      # { "{:.a1 .a2}",       %Scanner.Ial{attrs: ".a1 .a2", verbatim: ".a1 .a2"} },

      # { "  | a | b | c | ", %Scanner.TableLine{content: "  | a | b | c | ",
      #     columns: ~w{a b c} } },
      # { "  | a         | ", %Scanner.TableLine{content: "  | a         | ",
      #     columns: ~w{a} } },
      # { "  a | b | c  ",    %Scanner.TableLine{content: "  a | b | c  ",
      #     columns: ~w{a b c} } },
      # { "  a \\| b | c  ",  %Scanner.TableLine{content: "  a \\| b | c  ",
      #     columns: [ "a | b",  "c"] } },

          ]
  |> Enum.each(fn { text, %{__struct__: module}=type } ->
    tag =  module |> inspect |> String.split(".") |> Enum.reverse |> hd() |> String.to_atom
    quote do
      unquote do
        @tag tag
        test("line: '" <> text <> "'") do
          struct = unquote(Macro.escape type)
          indent = unquote(text) |> String.replace(@all_but_leading_ws, "") |> String.length
          struct = %{ struct | indent: indent, line: unquote(text), lnb: 42 }
          assert LP2.Scanner.scan_line({unquote(text), 42}) == struct
        end
      end
    end
  end)

end

# SPDX-License-Identifier: Apache-2.0
