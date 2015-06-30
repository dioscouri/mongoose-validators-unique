# mongoose-validators-unique

Unique validator for mongoose that supports conditions

## Usage

Add the validator to a schema

    var mongoose = require('mongoose');
    var uniqueValidator = require('mongoose-validators-unique');
    
    var schema = mongoose.Schema({});
    
    schema.plugin(uniqueValidator);
    
Use the validator

    var userSchema = mongoose.Schema({
        username: { type: String, required: true, unique: true },
        email: { type: String, unique: { conditions: { status: { $ne: 'archived' } } }, required: true },
        password: { type: String, required: true },
        status: { type: String }
    });

