# Backbone-Tracking

Adding version control like functionality to Backbone Models.

## The Need

Suppose you uhave a Model that you may change often, but may need to eventually back up to a previous state.
In Backbone itself you can go back at most one version but this is highly limiting and doesn't allow you
to do a bunch of cool things you might want to.  Wouldn't it be great if you could go back (or forward!)
as many versions as you wanted to on a whim?  Well thats what Backbone-Tracking allows you to do.

```coffeescript
user = new Backbone.Model {name: 'Andrew', age: 21}
user.startTracking() #You are now using Backbone-Tracking's version control!

user.set 'name', 'Bob'
user.commit()
user.revert()
user.get('name') #Will be Andrew!
user.progress()
user.get('name') #Will be Bob! 
```

## Usage

1. Simply grab the latest version of Backbone-Tracking (currently there is no minified version, but one will
will be coming soon!) and stick it in the `<head>` of your page after you load in Backbone.

    ```html
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script type="text/javascript" src="underscore.js"></script>
    <script type="text/javascript" src="backbone.js"></script>
    <script type="text/javascript" src="backbone-tracking.js"></script>
    ```
2. Instantiate a Model or take an Existing model and start tracking it!

    ```coffeescript
    model.startTracking()
    ```

3.  When you're done (or just not longer want to track the Model), you can stop tracking it.

    ```coffeescript
    model.stopTracking()
    ```

## API

###Model.startTracking (options)

Calling this method will start the tracking of the model it was called on.  To do this it adds a `version` attribute
as well as a `attributeArray` to the model being tracked.  Options can also be passed in that can override default
functionality:

Options:
  onChange: Setting the onChange option as a truthy value will cause a new version of the model to be created whenever the `change` event is fired.

  onSave: Setting the onSave options as a truhty value will cause a new version of the model to be created whenever the `sync` event is fired.  If both onChange and onSave are set, it will still only create one new version when a model is saved.

###Model.stopTracking

Calling this method will stop the tracking of the model it was called on.  This will delete both the `version` and `attributeArray` attributes on the model.  It will also unbind any events related to tracking.

###Model.commit

Creates a new version of the model.

###Model.revert (versionsBehind)

Rolls back the model by 1 version (if possible) unless the versionsBehind argument is passed.  If the versionsBehind argument is passed, then the model will roll back by that many versions (if possible).

###Model.revertToOriginal

Rolls back the model to the version it was at when tracking was started.

###Model.progress (versionsAhead)

Progresses the model by 1 version (if possible) unless the versionsAhead argument is passed.  If the versionsAhead argument is passed, then the model will progress by that many versions (if possible).

###Model.progressToNewest

Progresses the model to the most recently commited version.

###Model.clear

If changes have been made to the model and have not been commited, they will be replaced by the most recently commited version.

###Model.where (queryObj)

Search through the tracked history for a state where the queryObj's conditions are met.

    ```coffeescript
    model.where({name: 'Andrew', age: 10}) #Will search through the tracked history looking for a state where the name of the model was Andrew and the age was 10 and then set the model to that state.  Starts FROM THE BEGINNING OF THE HISTORY
    ```

## Changelog

### 0.1

Initial release!