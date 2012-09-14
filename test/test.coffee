describe "A Test Suite for Backbone Tracking", ->
	model = new Backbone.Model
	beforeEach ->
		model = new Backbone.Model

	afterEach ->
		model.stopTracking()

	describe "APIS", ->

		describe "Start Tracking", ->
			it "Should append the correct attributes to the model", ->
				model.startTracking()
				expect(model.version).toBeDefined()
				expect(model.attributeArray).toBeDefined()

		describe "Stop Tracking", ->
			it "Should remove the correct attributes as well as unbind any events related to tracking", ->
				model.startTracking {onChange: true, onSave: true}
				expect(model.version).toBeDefined()
				expect(model.attributeArray).toBeDefined()
				expect(_.size(model._callbacks)).toEqual 2
				model.stopTracking()
				expect(model.version).toBeUndefined()
				expect(model.attributeArray).toBeUndefined()
				expect(_.size(model._callbacks)).toEqual 0

		describe "Commit", ->
			afterEach ->
				model.stopTracking()

			describe "No Options Set", ->
				it "Should create a new version when the model is commited", ->
					model.startTracking()
					model.set 'name', 'Andrew'
					model.commit()
					expect(model.version).toEqual 1

			describe "OnChange Option Set", ->
				it "Should create a new version when the model is set", ->
					model.startTracking {onChange: true}
					model.set 'name', 'Andrew'
					expect(model.version).toEqual 1

			### TO DO Tests for OnSave Option Set ###

		describe "Revert", ->
			beforeEach ->
				model.set 'name', 'Andrew'
				model.startTracking {onChange: true}

			it "Should revert by one version when no argument is passed", ->
				model.set 'name', 'Bob'
				model.revert()
				expect(model.get 'name').toEqual 'Andrew'

			it "Should stay at the current version if no previous version exists", ->
				model.revert()
				expect(model.get 'name').toEqual 'Andrew'

			it "Should revert by the given number of versions if the argument versionsBehind is passed", ->
				model.set 'name', 'Bob'
				model.set 'name', 'Gerard'
				model.revert 2
				expect(model.get 'name').toEqual 'Andrew'

			it "Should stay on the current version if the number of versions passed is too large", ->
				model.set 'name', 'Bob'
				model.revert 20
				expect(model.get 'name').toEqual 'Bob'

		describe "Revert To Original", ->
			beforeEach ->
				model.set 'name', 'Andrew'
				model.startTracking {onChange: true}

			it "Should revert to the original state of the model", ->
				model.set 'name', 'Bob'
				model.set 'name', 'Gerard'
				model.revertToOriginal()
				expect(model.get 'name').toEqual 'Andrew'

		describe "Progress", ->
			beforeEach ->
				model.set 'name', 'Andrew'
				model.startTracking {onChange: true}

			it "Should progress by one version when no argument is passed", ->
				model.set 'name', 'Bob'
				model.revert()
				model.progress()
				expect(model.get 'name').toEqual 'Bob'

			it "Should stay at the current version if no more recent version exists", ->
				model.progress()
				expect(model.get 'name').toEqual 'Andrew'

			it "Should progress by the given number of versions if the argument versionsAhead is passed", ->
				model.set 'name', 'Bob'
				model.set 'name', 'Gerard'
				model.revertToOriginal()
				model.progress 2
				expect(model.get 'name').toEqual 'Gerard'

			it "Should stay on the current version if the number of versions passed is too large", ->
				model.set 'name', 'Bob'
				model.progress 20
				expect(model.get 'name').toEqual 'Bob'

		describe "Progress To Newest", ->
			beforeEach ->
				model.set 'name', 'Andrew'
				model.startTracking {onChange: true}

			it "Should progress to the newest version of the model", ->
				model.set 'name', 'Bob'
				model.set 'name', 'Gerard'
				model.revertToOriginal()
				model.progressToNewest()
				expect(model.get 'name').toEqual 'Gerard'

		describe "Clear", ->
			it "Should clear changes that were made but never commited", ->
				model.set 'name', 'Andrew'
				model.startTracking()
				model.set 'name', 'Bob'
				model.clear()
				expect(model.get 'name').toEqual 'Andrew'

		describe "Where", ->
			beforeEach ->
				model.set 'name', 'Andrew'
				model.startTracking {onChange: true}

			it "Should find the the correct version of the model based on the query", ->
				model.set 'name', 'Bob'
				model.set 'name', 'Gerard'
				model.where {name: 'Bob'}
				expect(model.get 'name').toEqual 'Bob'
