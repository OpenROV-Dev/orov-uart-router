alias Experimental.GenStage

defmodule TestUart do
	def start do
		{:ok, router} = GenStage.start_link(OrovUartRouter, "ttyUSB0" )   # starting from zero
		{:ok, printer} = GenStage.start_link(OrovMessagePrinter, :ok) # state does not matter

		GenStage.sync_subscribe(printer, to: router, min_demand: 0, max_demand: 1 )

		Process.sleep( :infinity )
	end
end