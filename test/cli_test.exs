defmodule CliTest do
  use ExUnit.Case
  doctest Ingester

  import Ingester.CLI, only: [parse_args: 1]

  test """
  odoo-logs -h 
  odoo-logs --help
  odoo-logs -foo bar --help --some-flag
  """ do
    assert parse_args(["odoo-logs", "-h"]) == :help_odoo_logs
    assert parse_args(["odoo-logs", "--help"]) == :help_odoo_logs
    assert parse_args(
      ["odoo-logs", "-foo", "bar", "--help", "--some-flag"]) == :help_odoo_logs
  end

  test """
  odoo-logs --logs-path /foo/bar
  """ do
    assert parse_args(["odoo-logs", "--logs-path", "/foo/bar"]) == {:logs, "/foo/bar"}
  end
  
end
