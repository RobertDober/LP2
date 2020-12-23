defmodule Test.LP2.ScannerTest do
  use ExUnit.Case

  @all_but_leading_ws ~r{\S.*}
  [
    { "",         %Token.Blank{} },
    { "        ", %Token.Blank{} },

    # { "<!-- comment -->", %Token.HtmlComment{complete: true} },
    # { "<!-- comment",     %Token.HtmlComment{complete: false} },

    { "- -",   %Token.ListItem{type: :ul, bullet: "-", content: "-", list_indent: 2} },
    # { "- - -", %Token.Ruler{type: "-"} },
    # { "--",    %Token.SetextUnderlineHeading{level: 2} },
    # { "---",   %Token.Ruler{type: "-"} },

    { "* *",   %Token.ListItem{type: :ul, bullet: "*", content: "*", list_indent: 2} },
    # { "* * *", %Token.Ruler{type: "*"} },
    { "**",    %Token.Text{content: "**", line: "**"} },
    # { "***",   %Token.Ruler{type: "*"} },

    { "_ _",   %Token.Text{content: "_ _"} },
    # { "_ _ _", %Token.Ruler{type: "_"} },
    { "__",    %Token.Text{content: "__"} },
    # { "___",   %Token.Ruler{type: "_"} },

    # { "# H1",       %Token.Heading{level: 1, content: "H1"} },
    # { "## H2",      %Token.Heading{level: 2, content: "H2"} },
    # { "### H3",     %Token.Heading{level: 3, content: "H3"} },
    # { "#### H4",    %Token.Heading{level: 4, content: "H4"} },
    # { "##### H5",   %Token.Heading{level: 5, content: "H5"} },
    # { "###### H6",  %Token.Heading{level: 6, content: "H6"} },
    # { "####### H7", %Token.Text{content: "####### H7"} },

    # { "> quote",    %Token.BlockQuote{content: "quote"} },
    # { ">    quote", %Token.BlockQuote{content: "   quote"} },
    # { ">quote",     %Token.BlockQuote{content: "quote"} },
    # { " >  quote",     %Token.BlockQuote{content: " quote"} },
    # { " >", %Token.BlockQuote{content: ""}},

    #1234567890123
    { "   a",         %Token.Text{content: "a", line: "   a"} },
    { "    b",        %Token.Indent{level: 1, content: "b"} },
    { "      c",      %Token.Indent{level: 1, content: "  c"} },
    { "        d",    %Token.Indent{level: 2, content: "d"} },
    { "          e",  %Token.Indent{level: 2, content: "  e"} },
    { "    - f",      %Token.Indent{level: 1, content: "- f"} },
    { "     *  g",    %Token.Indent{level: 1, content: " *  g"} },
    { "      012) h", %Token.Indent{level: 1, content: "  012) h"} },

    { "```",      %Token.Fence{delimiter: "```", language: "",     line: "```"} },
    # { "``` java", %Token.Fence{delimiter: "```", language: "java", line: "``` java"} },
    # { " ``` java", %Token.Fence{delimiter: "```", language: "java", line: " ``` java"} },
    # { "```java",  %Token.Fence{delimiter: "```", language: "java", line: "```java"} },
    # { "```language-java",  %Token.Fence{delimiter: "```", language: "language-java"} },
    # { "```language-élixir",  %Token.Fence{delimiter: "```", language: "language-élixir"} },
    # { "   `````",  %Token.Fence{delimiter: "`````", language: "", line: "   `````"} },

    # { "~~~",      %Token.Fence{delimiter: "~~~", language: "",     line: "~~~"} },
    # { "~~~ java", %Token.Fence{delimiter: "~~~", language: "java", line: "~~~ java"} },
    # { "  ~~~java",  %Token.Fence{delimiter: "~~~", language: "java", line: "  ~~~java"} },
    # { "~~~ language-java", %Token.Fence{delimiter: "~~~", language: "language-java"} },
    # { "~~~ language-élixir",  %Token.Fence{delimiter: "~~~", language: "language-élixir"} },
    # { "~~~~ language-élixir",  %Token.Fence{delimiter: "~~~~", language: "language-élixir"} },

    { "``` hello ```", %Token.Text{content: "``` hello ```"} },
    { "```hello```", %Token.Text{content: "```hello```"} },
    { "```hello world", %Token.Text{content: "```hello world"} },

    # { "<pre>",             %Token.HtmlOpenTag{tag: "pre", content: "<pre>"} },
    # { "<pre class='123'>", %Token.HtmlOpenTag{tag: "pre", content: "<pre class='123'>"} },
    # { "</pre>",            %Token.HtmlCloseTag{tag: "pre"} },
    # { "   </pre>",            %Token.HtmlCloseTag{indent: 3, tag: "pre"} },

    # { "<pre>a</pre>",      %Token.HtmlOneLine{tag: "pre", content: "<pre>a</pre>"} },

    # { "<area>",              %Token.HtmlOneLine{tag: "area", content: "<area>"} },
    # { "<area/>",             %Token.HtmlOneLine{tag: "area", content: "<area/>"} },
    # { "<area class='a'>",    %Token.HtmlOneLine{tag: "area", content: "<area class='a'>"} },

    # { "<br>",              %Token.HtmlOneLine{tag: "br", content: "<br>"} },
    # { "<br/>",             %Token.HtmlOneLine{tag: "br", content: "<br/>"} },
    # { "<br class='a'>",    %Token.HtmlOneLine{tag: "br", content: "<br class='a'>"} },

    # { "<hr />",              %Token.HtmlOneLine{tag: "hr", content: "<hr />"} },
    # { "<hr/>",             %Token.HtmlOneLine{tag: "hr", content: "<hr/>"} },
    # { "<hr class='a'>",    %Token.HtmlOneLine{tag: "hr", content: "<hr class='a'>"} },

    # { "<img>",              %Token.HtmlOneLine{tag: "img", content: "<img>"} },
    # { "<img/>",             %Token.HtmlOneLine{tag: "img", content: "<img/>"} },
    # { "<img class='a'>",    %Token.HtmlOneLine{tag: "img", content: "<img class='a'>"} },

    # { "<wbr>",              %Token.HtmlOneLine{tag: "wbr", content: "<wbr>"} },
    # { "<wbr/>",             %Token.HtmlOneLine{tag: "wbr", content: "<wbr/>"} },
    # { "<wbr class='a'>",    %Token.HtmlOneLine{tag: "wbr", content: "<wbr class='a'>"} },

    # { "<h2>Headline</h2>",               %Token.HtmlOneLine{tag: "h2", content: "<h2>Headline</h2>"} },
    # { "<h2 id='headline'>Headline</h2>", %Token.HtmlOneLine{tag: "h2", content: "<h2 id='headline'>Headline</h2>"} },

    # { "<h3>Headline",               %Token.HtmlOpenTag{tag: "h3", content: "<h3>Headline"} },

    # { id1, %Token.IdDef{id: "ID1", url: "http://example.com", title: "The title"} },
    # { id2, %Token.IdDef{id: "ID2", url: "http://example.com", title: "The title"} },
    # { id3, %Token.IdDef{id: "ID3", url: "http://example.com", title: "The title"} },
    # { id4, %Token.IdDef{id: "ID4", url: "http://example.com", title: ""} },
    # { id5, %Token.IdDef{id: "ID5", url: "http://example.com", title: "The title"} },
    # { id6, %Token.IdDef{id: "ID6", url: "http://example.com", title: "The title"} },
    # { id7, %Token.IdDef{id: "ID7", url: "http://example.com", title: "The title"} },
    # { id8, %Token.IdDef{id: "ID8", url: "http://example.com", title: "The title"} },
    # { id9, %Token.Indent{content: "[ID9]: http://example.com  \"The title\"",
    #     level: 1,       line: "    [ID9]: http://example.com  \"The title\""} },

    #   {id10, %Token.IdDef{id: "ID10", url: "/url/", title: "Title with \"quotes\" inside"}},
    #   {id11, %Token.IdDef{id: "ID11", url: "http://example.com", title: "Title with trailing whitespace"}},
    #   {id12, %Token.IdDef{id: "ID12", url: "]hello", title: ""}},


      { "* ul1", %Token.ListItem{ type: :ul, bullet: "*", content: "ul1", list_indent: 2} },
      { "+ ul2", %Token.ListItem{ type: :ul, bullet: "+", content: "ul2", list_indent: 2} },
      { "- ul3", %Token.ListItem{ type: :ul, bullet: "-", content: "ul3", list_indent: 2} },

      { "*     ul4", %Token.ListItem{ type: :ul, bullet: "*", content: "    ul4", list_indent: 6} },
      { "*ul5",      %Token.Text{content: "*ul5"} },

      { "1. ol1",          %Token.ListItem{ type: :ol, bullet: "1.", content: "ol1", list_indent: 3} },
      { "12345.      ol2", %Token.ListItem{ type: :ol, bullet: "12345.", content: "     ol2", list_indent: 7} },
      { "12345)      ol3", %Token.ListItem{ type: :ol, bullet: "12345)", content: "     ol3", list_indent: 7} },

      { "1234567890. ol4", %Token.Text{ content: "1234567890. ol4"} },
      { "1.ol5", %Token.Text{ content: "1.ol5"} },

      # { "=",        %Token.SetextUnderlineHeading{level: 1} },
      # { "========", %Token.SetextUnderlineHeading{level: 1} },
      # { "-",        %Token.SetextUnderlineHeading{level: 2} },
      # { "= and so", %Token.Text{content: "= and so"} },

      { "   (title)", %Token.Text{content: "(title)", line: "   (title)"} },

      # { "{: .attr }",       %Token.Ial{attrs: ".attr", verbatim: " .attr "} },
      # { "{:.a1 .a2}",       %Token.Ial{attrs: ".a1 .a2", verbatim: ".a1 .a2"} },

      # { "  | a | b | c | ", %Token.TableLine{content: "  | a | b | c | ",
      #     columns: ~w{a b c} } },
      # { "  | a         | ", %Token.TableLine{content: "  | a         | ",
      #     columns: ~w{a} } },
      # { "  a | b | c  ",    %Token.TableLine{content: "  a | b | c  ",
      #     columns: ~w{a b c} } },
      # { "  a \\| b | c  ",  %Token.TableLine{content: "  a \\| b | c  ",
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
