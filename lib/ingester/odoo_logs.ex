defmodule Ingester.OdooLogs do

  @moduledoc """
  Process odoo logs in a directory
  by creating a map (currently shows requests in a day)
  """

  def get_files(logs_path) do
    File.ls!(logs_path)
    |> Enum.filter(&(not File.dir?(&1)))
    |> Enum.map(&Path.absname(&1, logs_path))
  end

  def update_map(map, match) do
    case match do
      %{"date" => date, "db" => db} -> Map.update(map, db<>"_"<>date, 1, &(&1 + 1))
      _ -> map
    end
  end

  def process({:path, logs_path}) do
    get_files(logs_path)
    |> Enum.map(&process({:file, &1}))
    |> Enum.reduce(%{}, &(Map.merge(&1, &2, fn _, v1, v2 -> v1 + v2 end)))
  end

  def process({:file, file}) do
    File.stream!(file)
    |> Stream.map(&process({:line, &1}))
    |> Enum.reduce(%{}, fn match, acc -> update_map(acc, match) end)
  end

  def process({:line, line}) do
    case Regex.named_captures(
          ~r/(?<date>^\S+).*\s(?<db>\S+)\swerkzeug/, line) do
      nil -> %{}
      match -> match
    end
  end
  
end
