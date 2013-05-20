asyncForEach = (array, handler, callback) ->
	length = array.length
	index = -1

	processNext = ->
		index++
		if index < length
			item = array[index]
			handler item, processNext
		else
			callback()

	processNext()


flexibleCallback = (callbackFn=->) ->
	# Checks callback function arity (argument list length)
	# and returns two separate callbacks for success/fail.
	# This allows for both consice object-first callbacks
	# as well as err-first (err, object) callbacks.
	[success, fail] = [callbackFn, callbackFn]

	if callbackFn.length is 1
		fail = (err) -> throw err
	else if callbackFn.length is 2
		success = (object) -> callbackFn null, object

	return [success, fail]

module.exports = 
	asyncForEach: asyncForEach
	flexibleCallback: flexibleCallback
	flexCb: flexibleCallback