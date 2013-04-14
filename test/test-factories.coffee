Factory = require '../src/factory-castrado'

Backbone = require 'backbone'
class TestModel extends Backbone.Model
	create: (done) ->
		@id = @cid
		done()



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
	extends: 'user'
,
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
		from:
			factory: 'user'
			key: 'user_ids'
			type: 'ids[]'
		to:
			factory: 'user'
			key: 'user_ids'
			type: 'ids[]'


module.exports = Factory