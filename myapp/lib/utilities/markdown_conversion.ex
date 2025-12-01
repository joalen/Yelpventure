defmodule Utilities.MarkdownConversion do
  alias MDEx.Document

  def plain_text(path) do
    markdown = File.read!(path)
    doc = MDEx.parse_document!(markdown)
    flatten_text(doc)
    |> String.trim()
  end

  defp flatten_text(%Document{nodes: nodes}) when is_list(nodes) do
    nodes
    |> Enum.map(&flatten_text/1)
    |> Enum.join(" ")
  end

  # Any node with children
  defp flatten_text(%{nodes: nodes}) when is_list(nodes) do
    nodes
    |> Enum.map(&flatten_text/1)
    |> Enum.join(" ")
  end

  # Text nodes
  defp flatten_text(%{type: :text, literal: text}), do: text

  # Code blocks or fenced code (JSON, etc.)
  defp flatten_text(%{literal: literal}) when is_binary(literal), do: literal

  # Fallback for anything else
  defp flatten_text(_), do: ""

  def extract_json(text) do
    case Regex.run(~r/```json\s*\n(.*?)\n```/s, text) do
      [_, json] -> String.trim(json)
      nil ->
        case Regex.run(~r/```\s*\n(.*?)\n```/s, text) do
          [_, json] -> String.trim(json)
          nil -> text
        end
    end
  end
end
