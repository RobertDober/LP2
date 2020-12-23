defmodule Test.Token.TokenStructTest do
  use ExUnit.Case
  alias LP2.Scanner

  describe "Blank" do
    test "a Blank" do
      blank = %Scanner.Blank{line: "line", lnb: 42}
      assert blank.line == "line"
      assert blank.lnb == 42
      assert blank.indent == 0
    end
  end

  describe "UlListItem" do
    test "a UlListItem" do
      li = %Scanner.UlListItem{line: "line", lnb: 42}
      assert li.line == "line"
      assert li.lnb == 42
      assert li.indent == 0
    end
    test "more fields here" do
      li = %Scanner.UlListItem{line: "line", lnb: 42, list_indent: 5}
      assert li.list_indent == 5
    end
  end
end
