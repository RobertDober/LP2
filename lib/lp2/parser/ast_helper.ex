defmodule LP2.Parser.AstHelper do
  use LP2.Types
  @modueldoc false

  @typep _input_t :: binary() | quad_t()
  @spec raw_quad(atom(), _input_t(), attribute_ts()) :: quad_t()
  def raw_quad(type, content, atts \\ [])
  def raw_quad(type, content, atts) when is_binary(content) or is_tuple(content) do
    _raw_quad(type, [content], atts)
  end
  def raw_quad(type, content, atts) when is_list(content) do
    _raw_quad(type, content, atts)
  end

  @spec _raw_quad(atom(), list(binary()|quad_t()), attribute_ts()) :: quad_t()
  defp _raw_quad(type, content, atts) do
    {type, atts, content, %{}}
  end
  
end

