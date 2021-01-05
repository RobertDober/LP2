defmodule Test.Parser.ListTest do
  use ExUnit.Case
  alias LP2.Parser
  import Parser
  import Test.Support.MakeAst

  describe "simple as Bonjour ;)" do
    test "single ul list item" do
      input    = [
        "* a ul list item"
      ]
      expected = ok(ul(li("a ul list item")))
     
      assert parse(input) == expected
    end

    test "two list items → tight list" do
      input    = [
        "* first ul list item",
        "* second ul list item",
      ]
      expected = ok(ul([li("first ul list item"), li("second ul list item")]))
     
      assert parse(input) == expected
    end
    
    test "two list items → loose list" do
      input    = [
        "* first ul list item",
        "",
        "* second ul list item",
      ]
      expected = ok(ul([li(p("first ul list item")), li(p("second ul list item"))]))
     
      assert parse(input) == expected
    end
  end

  describe "on how lists end" do
    test "two blank lines do the trick" do
      input    = [
        "- a list",
        "",
        "",
        "not so much"
      ]
      expected = ok([ul(li("a list")), p("not so much")])
     
      assert parse(input) == expected
    end
  end

  
  
end
