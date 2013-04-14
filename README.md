# factory-castrado

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

### Defining factories
Coffeescript:
```
Factory	= require 'factory-castrado'
Model	= require('backbone').Model

counter = 1

# Define: name, model, attributes
Factory.define 'user', Model, 
	email: (cb) -> cb("user#{counter++}@test.com")
	name: "Test name"
	password: 'abc123'

# With associations, using options object:
Factory.define 'post',
	model: Model
	attributes:
		title: "Test title"
		content: "Test content"
	associations:
		user:
			factory: 'user'

```

### Using factories
Coffeescript:
```
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


## License

WTFPL v2