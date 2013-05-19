_ = require 'lodash'

try
	Backbone = require 'backbone'
catch e

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


factories = {}

define = (name, model, options, attributes) ->
	# Handle argument combinations
	switch arguments.length
		when 1
			# Only 1 parameter: (options)
			options = name
			param = undefined for param in [model, name]

		when 2
			# Params are (name, options)
			if model.attributes? or model.extends? or model.model?
				options = model
				model = undefined

			# Params are (name, function) - custom
			else if typeof model is 'function'
				# Custom fn factory
				factories[name] = model
				return true

		when 3
			# Params are (name, options, attributes)
			if model.attributes? or model.extends? or model.model?
				[options, attributes] = [model, options]
				model = undefined

			# Params are (name, model, attributes)
			if typeof model is 'function'
				attributes = options
				options = undefined

			# Params are (name, model, options)
			# (Nothing to do)

	model = options?.model ? model
	attributes = options?.attributes ? attributes ? {}
	name = options?.name ? name
	associations = options?.associations ? {}

	# This factory extends another
	if options?.extends
		parent = factories[options.extends]
		# Set model if not already set
		model ?= parent.model
		# Get copy of parent attributes, and merge
		parentAttrs = _.clone parent?.attributes ? {}
		_.defaults attributes, parentAttrs
		# Get copy of parent associations, and merge
		parentAssoc = _.clone parent?.associations ? {}
		_.defaults associations, parentAssoc


	factories[name] =
		model: model
		attributes: attributes
		associations: associations

build = (name, userAttrs, callback, noAssociations=false) ->
	if typeof userAttrs is 'function'
		[callback, userAttrs] = [userAttrs, {}]
	factory = factories[name]

	# Handle custom function factories
	if typeof factory is 'function'
		return factory(callback, userAttrs)

	model = factory.model

	associations = _.clone factory.associations
	if noAssociations then associations = []
	attributes = _.clone factory.attributes
	_.extend attributes, userAttrs

	setters = []

	get = (obj, key) ->
		if typeof obj.get is 'function' then obj.get(key) else obj[key]

	set = (obj, key, value) ->
		if typeof obj.set is 'function' then obj.set(key, value) else obj[key] = value

	# Compute associations
	asyncForEach _.keys(associations), (assocName, cb) ->
		assoc = associations[assocName]

		assocFactory = factories[assoc.factory ? assocName]
		setterFn = assoc.setter
		getterFn = assoc.getter ? (obj) -> return obj.id
		key = assoc.key
		switch assoc.type ? 'id'
			when 'id'
				key ?= assocName + '_id'
				do ->
					_key = key
					setterFn ?= (obj, val) ->
						obj.set _key, val


			when 'ids[]'
				key ?= assocName + '_ids'
				do ->
					_key = key
					setterFn ?= (obj, val) ->
						arrayField = get obj, _key
						arrayField ?= []

						unless val in arrayField
							arrayField.push?(val)
							set obj, key, arrayField




		# Pass in override association objects
		if attributes[assocName]
			_obj = associations[assocName] = attributes[assocName]
			delete attributes[assocName]
			_val = getterFn _obj

			assembledSetter = do ->
				val = _val
				return ((obj)->
					setterFn(obj, _val)
				)

			setters.push assembledSetter

			cb()
		# Already manually set
		else if attributes[key] and assoc.type is 'id'
			cb()

		# Build the associated object
		else
			create assoc.factory, (_obj) ->
				associations[assocName] = _obj
				val = getterFn _obj

				assembledSetter = do ->
					_val = val
					return ((obj)->
						# console.log 'SETTER', _val
						setterFn(obj, _val)
					)

				setters.push assembledSetter
				cb()

	, ->

		asyncForEach _.keys(attributes), (key, cb) ->
			fn = attributes[key]
			# Lazy attribute
			if typeof fn is 'function'
				fn (computedVal) ->
					attributes[key] = computedVal
					cb()
			else
				cb()
		, ->
			object = new model attributes

			for own key, val of associations
				object[key] = val

			processSetters = ->
				for setter in setters
					setter?(object)

			if Backbone? and object is Backbone.Model
				object.once 'setAssoc', processSetters
				object.trigger 'setAssoc'
			else
				processSetters()

			for own key, val of attributes
				set object, key, val

			callback(object)


create = (name, userAttrs, callback) ->
	if typeof userAttrs is 'function'
		[callback, userAttrs] = [userAttrs, {}]

	# Custom factory
	if typeof factories[name] is 'function'
		return factories[name](callback, userAttrs)

	build name, userAttrs, (doc) ->
		doc.create (err) ->
			if err then return callback null, err

			callback?(doc)

attributesFor = (name, attrs, callback) ->
	if typeof attrs is 'function'
		[callback, attrs] = [attrs, {}]

	build name, attrs, (doc) ->
		callback doc.toJSON()
	, "noAssociations"



Factory = create
Factory.define = define
Factory.build = build
Factory.create = create
Factory.attributesFor = attributesFor


module.exports = Factory