mongoose = require('mongoose')
mongoose.connect("mongodb://192.168.59.103/test")
Schema = mongoose.Schema
uniqueValidator = require('../index')
should = require('should')

mongoose.plugin(uniqueValidator)

unpluggedSchema = new Schema({
    status: {type: String},
    name: {type: String}
  },{
    collection: "models"
  }
)

notUniqueNameSchema = new Schema({
    status: {type: String},
    name: {type: String}
  },{
    collection: "models"
  }
)

uniqueNameSchema = new Schema({
  status: {type: String},
  name: {type: String, validators: {unique: true}}
  },{
    collection: "models"
  }
)



uniqueNameOverScopeSchema = new Schema({
    status: {type: String},
    name: {type: String, validators: {unique: {scope: "status"}}}
  },{
    collection: "models"
  }
)


uniqueNameOverConditionSchema = new Schema({
    status: {type: String},
    name: {type: String, validators: {unique: {condition: {status: "active"}}}}
  },{
    collection: "models"
  }
)

Unplugged = mongoose.model('Unplugged', unpluggedSchema)
UniqueName = mongoose.model('UniqueName', uniqueNameSchema)
NotUniqueName = mongoose.model('NotUniqueName', notUniqueNameSchema)
UniqueNameOverScope = mongoose.model('UniqueNameOverScope', uniqueNameOverScopeSchema)
UniqueNameOverCondition = mongoose.model('UniqueNameOverConditionSchema', uniqueNameOverConditionSchema)



describe "Model", () ->
  starters = [
    {status: "active", name: "activeTest"},
    {status: "inactive", name:"inactiveTest"}
  ]

  beforeEach (done) ->
    Unplugged.remove({}, () ->
      Unplugged.create(model) for model in starters
      done()
    )

  it "NotUniqueName should allow duplicates", (done) ->
    model = new NotUniqueName({status: "active", name: "activeTest"})
    model.save done

  it "UniqueName should not allow a duplicate name", (done) ->
    model = new UniqueName({status: "dummy", name: "activeTest"})
    model.save (err) ->
      should.exist(err)
      err.name.should.equal("ValidationError")
      should.exist(err.errors.name)
      err.errors.name.type.should.equal("unique")
      done()

  it "UniqueName should allow an unique name", (done) ->
    model = new UniqueName({status: "active", name: "uniqueTest"})
    model.save done

  it "UniqueNameOverScope should allow an unique name in a different scope", (done) ->
    model = new UniqueNameOverScope({status: "inactive", name: "activeTest"})
    model.save done


  it "UniqueNameOverScope should not allow a duplicate name in the same scope", (done) ->
    model = new UniqueNameOverScope({status: "active", name: "activeTest"})
    model.save (err) ->
      should.exist(err)
      err.name.should.equal("ValidationError")
      should.exist(err.errors.name)
      err.errors.name.type.should.equal("unique")
      done()


  it "UniqueNameOverScope should allow an duplicate name outside the condition", (done) ->
    model = new UniqueNameOverCondition({status: "inactive", name: "inactiveTest"})
    model.save done


  it "UniqueNameOverScope should not allow a duplicate name inside the condition", (done) ->
    model = new UniqueNameOverCondition({status: "active", name: "activeTest"})
    model.save (err) ->
      should.exist(err)
      err.name.should.equal("ValidationError")
      should.exist(err.errors.name)
      err.errors.name.type.should.equal("unique")
      done()
