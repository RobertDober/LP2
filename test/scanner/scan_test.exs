defmodule Test.Scanner.ScanTest do
  use ExUnit.Case

  alias LP2.Scanner
  import Scanner, only: [scan_lines: 1]

  describe "empty" do
    test "handles it" do
      assert scan_lines([]) == []
    end
  end

  describe "mutiple lines" do
    test "blank" do
      assert scan_lines("\n ") == [%Scanner.Blank{indent: 0, line: "", lnb: 1}, %Scanner.Blank{indent: 1, line: " ", lnb: 2}]
    end
  end

  describe "the kind of input we will test in the near future" do
    test "" do
      input    = [
        "* Hello",
        "1. World",
        "",
        "** Text"
      ]
      expected = [
        %Scanner.UlListItem{indent: 0, bullet: "*", content: "Hello", line: "* Hello", lnb: 1, list_indent: 2},
        %Scanner.OlListItem{indent: 0, bullet: "1.", content: "World", line: "1. World", lnb: 2, list_indent: 3},
        %Scanner.Blank{indent: 0, line: "", lnb: 3},
        %Scanner.Text{indent: 0, line: "** Text", content: "** Text", lnb: 4}
      ]
      assert scan_lines(input) == expected
    end
  end
end
