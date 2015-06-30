module.exports = (schema, options) ->
    message = 'Expected `{PATH}` to be unique. Value: `{VALUE}`'

    schema.eachPath (path, schemaType) ->
        if(schemaType.options?.validators?.unique?)
            uniqueness = schemaType.options.validators.unique
            if(uniqueness == true)
                schemaType.validators.push({validator: validator(path), message: message, type: 'unique'})
            if( typeof uniqueness == "object" and uniqueness.scope?)
                schemaType.validators.push({
                    validator: validator(path, uniqueness.scope),
                    message: message,
                    type: 'unique'
                })
            if( typeof uniqueness == "object" and uniqueness.condition?)
                schemaType.validators.push({
                    validator: validator(path, uniqueness.condition),
                    message: message,
                    type: 'unique'
                })

buildQuery = (path, value, id) ->
    target = {}
    target[path] = value
    query = {
        $and: []
    }
    query.$and.push({_id: {$ne: id}})
    query.$and.push(target)
    return query


validator = (path, scopeOrCondition) ->
    return (value, respond) ->
        model = this.model(this.constructor.modelName)
        query = buildQuery(path, value, this._id)

        if(scopeOrCondition?)
            q = {}
            if(typeof scopeOrCondition == "string" or scopeOrCondition.constructor.name == "String")
                q[scopeOrCondition] = this[scopeOrCondition]
            else
                q = scopeOrCondition
            query.$and.push(q)
        model.findOne(query, (err, document) ->
            respond(document? == false)
        )

