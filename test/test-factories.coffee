Factory = require '../src/factory-castrado'
Backbone = require 'backbone'

class TestModel extends Backbone.Model
	create: (done) ->
		@id = @cid
		done()

class PlainTestModel extends Object

Factory.define 'plain',
	model: PlainTestModel
	attributes:
		name: "David"
		password: "crap123"

Factory.define 'plain-extended',
	extends: 'plain'
	attributes:
		extended: true
		set: -> return "override"

Factory.define 'plain-assoc',
	extends: 'plain'
	attributes:
		extended: true
	associations:
		community:
			factory: 'community-assoc'

Factory.define 'user',
	model: TestModel
	attributes:
		name: "David"
		password: "crap123"

Factory.define 'user-extended',
	extends: 'user'
	attributes:
		extended: true

Factory.define
	name: 'user-options'
	extends: 'user'
	attributes:
		extended: true

Factory.define 'user-params',
	# Options
	extends: 'user'
,
	# Attributes
	extended: true


Factory.define 'user-assoc',
	model: TestModel
	attributes:
		name: "David"
		password: "crap123"
	associations:
		community:
			factory: 'community-assoc'


Factory.define 'community-assoc',
	model: TestModel
	attributes:
		state: "California"
		country: "USA"


Factory.define 'post-assoc',

	model: TestModel
	attributes:
		title: "Test title"
	associations:
		community:
			factory:'community-assoc'
		author:
			factory:'user-assoc'

Factory.define 'message',
	model: TestModel
	attributes:
		subject: "Hi there"
	associations:
		community:
			factory: 'community-assoc'
		from:
			factory: 'user'
			key: 'user_ids'
			type: 'ids[]'
		to:
			factory: 'user'
			key: 'user_ids'
			type: 'ids[]'


Factory.define 'message between two users', (callback) ->

	Factory.create 'user-assoc', (user1) ->

		Factory.create 'user-assoc', user: user1, community: user1.community, (user2) ->

			Factory.create 'message',
				to: user1
				from: user2
				community: user1.community
			, (message) ->

				callback message, user1, user2


module.exports = Factory