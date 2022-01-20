
//asi se importan librerias
const fs = require('fs');
const { createRequire } = require('module');
const { crearArchivo }=require('./helpers/multiplicar');
const argv = require('yargs').argv;
let salida = '';
console.clear();
//desde aqui se insertan valores por consola=======================
//console.log(process.argv);
// const [ , , arg3 = 'm=5' ]=process.argv;
// const [ , m] = arg3.split('=');
console.log(process.argv);
console.log(argv)
console.log('m: yargs', argv.m);
//================================================================
//const m=11;

// crearArchivo(m)
//      .then (nombreArchivo=>console.log(nombreArchivo, 'creado'))
//      .catch(err => console.log(err));


//-------------------------------------
// console.log('=================')
// console.log(`Tabla del ${m}`)
// console.log('=================')
// for (let i=1;i<11;i++){
//     const t = m*i;
//     //console.log(m, 'x', i, '=', t)
//     //console.log(`${m} x ${i} = ${t}`)
//     //console.log(`${m} x ${i} = ${m*i}\n`)
//     salida += `${m} x ${i} = ${m*i}\n`
// }
// console.log(salida);
// //si no se coloca path o ruta entonces toma por defecto la ubicacion actual del archivo
// //el Sync se necesita ejecutar con un try y un catch para que funciones si se ´resenta un error

// fs.writeFileSync(`tabla-${m}.txt`, salida);

// console.log(`tabla-${m}.txt creado`);
//----------------------------------------------
// //este metodo es asincrono 
// fs.writeFile(`tabla-${m}.txt`, salida),(err) => {
//        if (err) throw err;
//        console.log(`tabla-${m}.txt creado`);
//      };
//console.log(salida)
//capitulo 30 no se trabajo, verlos de nuevo
// const data = new Uint8Array(Buffer.from('Hello Node.js'));
// writeFile('Tabla-del-5.txt', data, (err) => {
//   if (err) throw err;
//   console.log('Guardado con exito !!');
// });
