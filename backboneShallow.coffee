###
Backbone Shallow v1.0.0 - An extension of Backbone Models and Collections that allow for linked copies of models and collections.

Copyright (c) 2012
MIT Licensed (LICENSE)

Dependencies: JQuery, Underscore.js, Backbone.js
###

### 
A private method that allows for all attributes of a Model/Collection to be copied over to another Model/Collection.
Does not pollute the copied to object with the prototype of the original object 
###

_extend = (other)->
	for key, value of other
		if other.hasOwnProperty key
			@[key] = other[key]
	@.__proto__ = other.__proto__
	@

###
Creates a new Backbone Model which is linked to the original.  Options are as follows:
	updateOnSave: If a function is passed, the function will be called on the shallowModel firing a "sync" event.
								If a truthy value is passed, the shallowModel will update its linked model on the shallowModel firing a "sync" event.
	updateOnDestroy: If a function is passed, the function will be called on the shallowModel firing a "destroy" event.
###

Backbone.Model::createShallowModel = (options)->
	shallowModel = (new Backbone.Model)._extend(@)
	shallowModel.originalModel = @
	@.shallowModel = shallowModel
	if options?.updateOnSave?
		shallowModel.on 'sync', => if typeof(cb) == "function" then cb() else @.commitModelChanges()
	else if options?.updateOnDestroy?
		shallowModel.on 'destroy', => options.updateOnDestroy()
	shallowModel

###
Creates a new Backbone Collection which holds shallowModels of all the models in the original collection.  
Options passed here are passed along to the shallowModels created, and are the same as those listed above.
###

Backbone.Collection::createShallowCollection = (options)->
	shallowCollection = (new Backbone.Collection)._extend(@)
	shallowCollection.originalCollection = @
	@.shallowCollection = shallowCollection
	tempShallowArray = []
	for model in @.models
		tempShallowArray.push model.createShallowModel(options)
	shallowCollection.models = tempShallowArray
	shallowCollection
###
Sets the original model with all the attributes of the shallowModel
###
Backbone.Model::commitModelChanges = -> @.originalModel.set @.attributes

###
First sets the original model with all the attributes of the shallowModel IF the model is a shallowModel
If the model is new, it is added to the original collection
###

Backbone.Collection::commitCollectionChanges = ->
	for model in @.models
		if !@.originalCollection.getByCid model.cid
			@.originalCollection.add model
		else if model.originalModel?
			model.commitModelChanges()

###
Clears all events on the shallowModel
###
Backbone.Model::cleanupShallowModel = -> @.shallowModel.off()

###
Clears all events on the shallowCollection
If the cleanUpModels flag is set, then all of the collections models (which are shallow) will have their events cleared
###

Backbone.Collection::cleanupShallowCollection = (cleanUpModels)->
	@.shallowCollection.off()
	if cleanUpModels?
		for model in @.shallowCollection.models
			model.off()

###
Protoyping the extend function onto both Backbone Models and Collections
###
Backbone.Model::_extend = _extend
Backbone.Collection::_extend = _extend