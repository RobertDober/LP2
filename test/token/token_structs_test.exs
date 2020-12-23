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

  describe "ListItem" do
    test "a ListItem" do
      li = %Scanner.ListItem{line: "line", lnb: 42}
      assert li.line == "line"
      assert li.lnb == 42
      assert li.indent == 0
    end
    test "more fields here" do
      li = %Scanner.ListItem{line: "line", lnb: 42, type: :ol, list_indent: 5}
      assert li.type == :ol
      assert li.list_indent == 5
    end
    test "default value for type" do
      li = %Scanner.ListItem{}
      assert li.line == "" 
      assert li.type == :ul 
      
    end
  end
end
