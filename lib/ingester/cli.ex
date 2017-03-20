defmodule Ingester.CLI do

  @moduledoc """
  Parse command line arguments
  """

  def run(args) do
    parse_args(args)
    |> process
  end

  def parse_args(["odoo-logs" | args]) do
    {parsed, _, _} = OptionParser.parse(args,
      switches: [
        help: :boolean,
        logs_path: :string
      ],
      aliases: [h: :help])
    case Enum.into(parsed, %{}) do
      %{help: _} -> :help_odoo_logs
      %{logs_path: logs_path} -> {:logs, logs_path}
      _ -> :error
    end
  end

  def parse_args(_) do
    :help
  end

  def process(:help) do
    IO.puts """
    Tool for data ingestion.
    
    ingester odoo_logs # ingest odoo logs
    """
  end

  def process(:help_odoo_logs) do
    IO.puts """
    ingester odoo_logs
    
    --help      # this help message
    --logs-path # path to logs that will be ingested
    """
  end

  def process(:error) do
    IO.puts "Error!"
  end

  def process({:logs, logs_path}) do
    IO.puts "Processing logs in #{logs_path}"
    Ingester.OdooLogs.process(logs_path)
  end
  
end
