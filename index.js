module.exports = (schema, options) {
    var message = 'Expected `{PATH}` to be unique. Value: `{VALUE}`';

    schema.eachPath (path, schemaType) {
        if(schemaType.options?.validators?.unique?) {
            var uniqueness = schemaType.options.validators.unique;
            if(uniqueness == true) {
                schemaType.validators.push({validator: validator(path), message: message, type: 'unique'})
            }
                
            if( typeof uniqueness == "object" and uniqueness.scope?) {
                schemaType.validators.push({
                    validator: validator(path, uniqueness.scope),
                    message: message,
                    type: 'unique'
                });
            }
            
            if( typeof uniqueness == "object" and uniqueness.condition?) {
                schemaType.validators.push({
                    validator: validator(path, uniqueness.condition),
                    message: message,
                    type: 'unique'
                });
            }
        }
    }

var buildQuery = (path, value, id) {
    var target = {};
    target[path] = value;
    var query = {
        $and: []
    };
    query.$and.push({_id: {$ne: id}});
    query.$and.push(target);
    return query;
}

var validator = (path, scopeOrCondition) {
    return (value, respond) {
        var model = this.model(this.constructor.modelName);
        var query = buildQuery(path, value, this._id);

        if(scopeOrCondition?) { 
            var q = {};
            if (typeof scopeOrCondition == "string" or scopeOrCondition.constructor.name == "String") {
                q[scopeOrCondition] = this[scopeOrCondition]
            } else {
                q = scopeOrCondition
            }
            
            query.$and.push(q)
        }
        
        model.findOne(query, (err, document){
                respond(document? == false)
            }
        )
    }
}
