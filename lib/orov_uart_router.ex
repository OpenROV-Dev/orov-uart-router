alias Experimental.GenStage

defmodule OrovUartRouter do
	use GenStage

	def init( usb_interface ) do
		{:ok, pid} = Nerves.UART.start_link
		status = Nerves.UART.open( pid, usb_interface, speed: 115200, active: false )

		{ :producer, { status, pid, <<>> } }
	end

	def handle_demand( demand, { status, pid, data } ) when demand > 0 do

		{ events, [ leftover ] } = recv( data, pid )

    	{:noreply, events, { status, pid, leftover } }
	end

	def recv( data, pid ) do
		# Read any available bytes
		{ :ok, bytes } = Nerves.UART.read( pid, 5000 )

		results = [ data, bytes ] |> Enum.join |> process_buffer

		case results do
			{ [], [ leftover ] } -> 
				recv( leftover, pid )
			_ ->
				results
		end
	end

	def handle_message( message ) do
        case String.split( message, ":" ) do
            [ field, value ] ->
                { :ok, field, value }
            _ ->
                { :bad_format }
        end
    end

    def handle_messages( messages ) do
        Enum.map( messages, &handle_message/1 )
    end

    def process_buffer( data ) do
        { complete, leftover } = Enum.split( String.split( data, ";" ), -1 )
        { handle_messages( complete ), leftover }
    end

end
