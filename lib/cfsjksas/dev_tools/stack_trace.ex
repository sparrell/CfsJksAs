defmodule Cfsjksas.DevTools.StackTrace do
  def go() do
    {:current_stacktrace, stack} = Process.info(self(), :current_stacktrace)

    stack
    |> Enum.drop(2)      # skip Process.info/2 and current function
    |> Enum.take(5)      # next few callers
    |> Enum.each(fn entry ->
      IO.puts(Exception.format_stacktrace_entry(entry))
    end)

  end
end
