const { read } = require('fs');

require('colors');
const mostrarMenu=()=>{
    console.clear();
    console.log('============================')
    console.log('   Selecciones una opcion')
    console.log('============================')

    console.log(`1. Crear Tareas`);
    console.log(`2. Listar Tareas`);
    console.log(`3. Listar Tareas Completadas`);
    console.log(`4. Listar Tareas Pendientes`);
    console.log(`5. Completar Tarea(s)`);
    console.log(`6. Borrar Tarea`);
    console.log(`0. Salir\n`);
const readLine = require('readline').createInterface({
    input: process.stdin,
    output: process.stdout
});
readLine.question('Seleciones una opcion: ', (opt)=>{
    readLine.close();
} )

const pausa =() => {
    const readline =require('readline').createInterface({
    input: process.stdin,
    output: process.stdout
    });

    readline.question(`Presione ${'ENTER'.green}`, (opt)=>{
        readline.close();
    })
}


}
module.exports = {
    mostrarMenu
}