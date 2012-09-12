# Backbone-Shallow

An extension of Backbone Models and Collections that allow for linked copies of models and collections.

## The Need

Suppose you have a model (or a collection of models) that you need to change and update constantly, but dont
want to keep the changes unless the user does something (usually saving to the server).  Simply make a shallow
copy of the model then sync them as needed!

```javascript
var user = new Backbone.Model({
  name: 'Andrew'
});

var shallow_user = user.createShallowModel()

shallow_user.set('name', 'Bob')
shallow_user.set('age', 10)

//Now assume the user did something that should make the changes permenant
shallow_user.updateLinkedModel()

//And now if we check the user, all their attributes will have been updated!
user.get('name') //Will be "Bob"
user.get('age') //Will be 10
```

## Usage

1. Simply grab the latest version of backbone-shallow (currently there is no minified version, but one will
will be coming soon!) and stick it in the `<head>` of your page after you load in Backbone.

    ```html
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script type="text/javascript" src="underscore.js"></script>
    <script type="text/javascript" src="backbone.js"></script>
    <script type="text/javascript" src="backboneShallow.js"></script>
    ```
Then simply make shallow copies of Models or Collections as needed and youre ready to go!

## Shallow Collections

Shallow collections can be made much the same shallow models, except that shallow versions of each of the models
in the original collection will have corresponding shallow models and inserted into the shallow collection.
And don't worry if you add new models to your shallow collection, they will be placed into the original collection
when the shallow collection is updated.

## Changelog

#### 1.0.0

Initial release!