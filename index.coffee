net = require 'net'
csv = require 'csv-parser'

HOST = process.argv[2]
PORT = process.argv[3]

console.log "SIMCAP v0.0.0 host: #{ HOST } port: #{ PORT } now: #{ Date.now() }"

unless HOST and PORT
	console.log "Usage: coffee index.coffee <HOST> <PORT>"
	process.exit(0)

console.log "Connecting to #{ HOST }:#{ PORT }"


normalizeFloat = (data) ->
	float = parseFloat( data )
	float.toFixed(2)

onSensorLogData = (data) ->
	# console.log( data )
	return unless data.motionMagneticFieldCalibrationAccuracy is '1'
	console.log "Acc: #{ data.motionMagneticFieldCalibrationAccuracy } x: #{ normalizeFloat data.motionMagneticFieldX } y: #{ normalizeFloat data.motionMagneticFieldY } z: #{ normalizeFloat data.motionMagneticFieldZ }"

client = net.connect PORT, HOST, ->
	console.log "Connected to #{ HOST }:#{ PORT }"
	csvStream = client.pipe( csv() )
	csvStream.on( 'data', onSensorLogData )

client.on 'end', ->
	console.log "Disconnected from #{ HOST }:#{ PORT }"
	process.exit(0)

