const argv = require('yargs')
.option('m', {
    alias: 'mul',  
    describe: 'base de la multiplicacion',
    type: 'number',
    //default: true
    demandOption: true,
})
.option('h', {
    alias: 'hasta',  
    describe: 'rango de la multiplicacion',
    type: 'number',
    default: 10,
    demandOption: true,
})
.option('l', {
    alias: 'listar',
    demandOption: true,
    default: false,
    describe: 'me lista la tabla de la variable',
    type: 'boolean'
})
.check((argv, options) => {
    console.log('yargs', argv)
    if(isNaN(argv.mul)){
        throw 'la variable "m" debe ser un numero'
    }
    return true;
  })
  
.argv;
module.exports = argv;