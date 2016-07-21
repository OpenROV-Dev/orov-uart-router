alias Experimental.GenStage

defmodule OrovMessagePrinter do
  use GenStage

  def init(:ok) do
    {:consumer, :the_state_does_not_matter}
  end

def handle_events(events, _from, state) do
    # Wait for a second.
    :timer.sleep(10)

    # Inspect the events.
    IO.inspect(events)

    # We are a consumer, so we would never emit items.
    {:noreply, [], state}
  end
end

