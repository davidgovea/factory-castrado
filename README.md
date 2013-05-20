# factory-castrado
[![Build Status](https://travis-ci.org/davidgovea/factory-castrado.png)](https://travis-ci.org/davidgovea/factory-castrado)

Factory Castrado is a library for Node.js which provides factories for objects creation. It is designed for use with Backbone-style models which use ```new Model(attributes)``` for initialization and ```model.create(function(err, model){...})``` for saving.

It is highly inspired by:
- [factory_girl](https://github.com/thoughtbot/factory_girl) - ruby
- [factory-lady](https://github.com/petejkim/factory-lady) - node.js
- [factory-boy](https://github.com/kbackowski/factory-boy) - node.js

## Installation

Node.js:

```
npm install factory-castrado
```

## Usage

### Model requirements
Coffeescript:
```coffee
# factory-castrado puts only one requirement on models: 
# they *must be constructor functions* that accept an attributes object.
# Your model must be comply with:
model = new Model(attributes)

# In order to save to model to a database during Factory.create, 
# factory-castrado uses "model.create (err, model) ->"
Model::create = (done) ->
	# ...Insert into db...
	done(error, this)

# If no create method is found, the model is passed back without saving.

# If a non-backbone object is given for a factory's models,
# the model.get() and model.set() methods are shimmed.

```

### Defining factories
Coffeescript:
```coffee
Factory		= require 'factory-castrado'
Model		= require('backbone').Model
PlainModel	= class extends Object # Bare object

counter = 1

# Define with (name, model, attributes)
Factory.define 'user', Model,
	email: (cb) -> cb("user#{counter++}@test.com")
	name: "Test name"
	password: 'abc123'

# With associations, using (name, options):
Factory.define 'post',
	model: Model
	attributes:
		title: "Test title"
		content: "Test content"
	associations:
		user:				# This creates an embedded post.user object, and a user_id attribute
			factory: 'user'	# Defaults to association name (user here)
			key: 'user_id'	# Defaults to name + _id

# Non-Backbone objects work the same:
# NOTE: factory-castrado shims model.get() and model.set() methods
Factory.define 'session', PlainModel,
	id: (cb) -> cb(Math.random())
	expires: (cb) -> cb (require 'moment')().add('days', 7).toDate()

Factory.define 'plainUser',
	model: PlainModel,
	attributes:
		name: "Test"
	associations:
		session:				
			factory: 'session'	# Attaches embedded user.session
			key: 'session_id'	# Attaches user.session_id foreign key

			# On a backbone-style model, the foreign key would be in 
			# the model's attributes hash, accessed using user.get('session_id')

```

### Using factories
Coffeescript:
```coffee
Factory.build 'user', (user) ->
	# user is an unsaved user model

Factory.build 'user', name:"New", (user) ->
	# user is an unsaved user model with name "New"

Factory.build 'post', (post) ->
	# post is an unsaved post model
	# post.user is a saved associated user model
	# post has new attribute 'user_id' with the user's id

Factory.create 'user', (user) ->
	# User is SAVED model

```

### Associations
Coffeescript:
```coffee
Factory.define 'post',
	model: Model
	associations:
		user:
			# Defaults to association name (user here)
			factory: 'user'

			# Defaults to name + _id
			key: 'user_id'

			# Gets foreign key from associated model
			# Default getter, just grabs id
			getter: (assocObj) -> return assocObj.id

			# Sets foreign key on factory's built model
			# Default setter (pseudocode - uses 'key' from above if setter not overridden)
			setter: (obj, val) -> obj.set {{key}}, val

			 # Conveniently provides default setters/getters
			type: 'id' # Currently supported: "id", "ids[]"
			# Using type: "ids[]" provides a default setter than inserts id into object's array of ids


# Id-array associations
# This will generate a message model with:
# user_ids: [id1, id2]
# as well as user models attached directly at msg.to , msg.from
Factory.define 'message',
	model: MessageModel
	attributes:
		title: "Hello World"
	associations:
		from:
			factory: 'user'
			key: 'user_ids'
			type: 'ids[]'
		to:
			factory: 'user'
			key: 'user_ids'
			type: 'ids[]'
```

### Custom Factories
Coffeescript:
```coffee
# Custom factories can be defined with a function
Factory.define 'two users and a random number', (callback) ->
	Factory.create 'user', (user1) ->
		Factory.create 'user', (user2) ->

			randomNum = ~~(Math.random()*10)
			callback(user1, user2, randomNum)

# Using it:
Factory.create 'two users and a random number', (user1, user2, randomNum) ->

# Custom attributes will be passed through to
# custom factories after callback parameter:
Factory.define 'helloworld', (callback, options) ->
	data = "Hello World"
	if options?.caps
		return callback(data.toUpperCase())

	callback(data)

Factory.create 'helloworld', (string) -> # string == 'Hello World'
Factory.create 'helloworld', caps:true, (string) -> # string == 'HELLO WORLD'
```

### Getting attributes with attributesFor
Coffeescript:
```coffee
# Get raw object of attributes
Factory.attributesFor 'user', (attrs) ->

# Specify some options
Factory.attributesFor 'user', name: "Bob", (attrs) ->

```


## License

WTFPL v2
