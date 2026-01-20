defmodule Utilities.JsonToText do
  def to_text(path) do
    case File.read(path) do
      {:ok, content} ->
        case Jason.decode(content) do
          {:ok, json_map} ->
            {:ok, Jason.encode!(json_map, pretty: true)}
          {:error, decode_err} ->
            {:error, {:json_decode_failed, decode_err}}
        end
      {:error, reason} ->
        {:error, {:file_read_failed, reason}}
    end
  end
end
