Backbone.Model::setSilently = (attributes)-> @set attributes, {silent: true}

Backbone.Model::startTracking = (options)->
	@version = 0
	@attributeArray = [$.extend(true, {}, @attributes)]
	if options?.onChange?
		@on 'change', (=> @commit()), @attributeArray	
	if options?.onSave?
		@on 'sync', (=> if !options?.onChange? then @commit()), @attributeArray

Backbone.Model::stopTracking =->
	@off null, null, @attributeArray
	delete @version
	delete @attributeArray

Backbone.Model::clear =->
	@setSilently @attributeArray[@version]

Backbone.Model::revert = (versionsBehind)->
	if @version == 0 then return
	versionNumber = @version - (versionsBehind || 1)
	if versionNumber >= 0
		@setSilently @attributeArray[versionNumber]
		@version = versionNumber

Backbone.Model::revertToOriginal = ->
	@setSilently @attributeArray[0]
	@version = 0

Backbone.Model::progress = (versionsAhead)->
	if @version == (@attributeArray.length - 1) then return
	versionNumber = @version + (versionsAhead || 1)
	if versionNumber < @attributeArray.length
		@setSilently @attributeArray[versionNumber]
		@version = versionNumber

Backbone.Model::progressToNewest = ->
	@setSilently @attributeArray[@attributeArray.length-1]
	@version = @attributeArray.length-1

### Searches older commits first###
Backbone.Model::where = (queryObj)->
	tempVersion = 0
	for commit in @attributeArray
		flag = true
		for key, value of queryObj
			if @get key != value then (flag = false)
		if flag == true
			@version = tempVersion
			@setSilently commit
			return

Backbone.Model::commit = ->
	@version++
	@attributeArray.push $.extend(true, {}, @attributes)