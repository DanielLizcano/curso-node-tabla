
const fs = require('fs');
const { resolve } = require('path/posix');
//METODO NORMAL PARA CREAR TABLAS====================================
// const crearArchivo =(m = 5) =>{
    
//     console.log('=================');
//     console.log('Tabla del:', m);
//     console.log('=================');
        
//     let salida = '';
     
//     for (let i=1;i<11;i++){      
//         salida += `${m} x ${i} = ${m*i}\n`;
//     }
//     console.log(salida);
    
//     fs.writeFileSync(`tabla-${m}.txt`, salida);
    
//     console.log(`tabla-${m}.txt creado`);
// }
//===============================================================


//METODO EN PROMESA PARA CREAR TABLAS =================================
// const crearArchivo =(m = 5) =>{
//     return new Promise((resolve, reject)=>{
//     console.log('=================');
//     console.log('Tabla del:', m);
//     console.log('=================');
        
//     let salida = '';
     
//     for (let i=1;i<11;i++){      
//         salida += `${m} x ${i} = ${m*i}\n`;
//     }
//     console.log(salida);
    
//     const archivo=fs.writeFileSync(`tabla-${m}.txt`, salida);
//     resolve(`tabla-${m}.txt`)
// });
//     console.log(`tabla-${m}.txt creado`);
//}

//===============================================================


//METODO ASYNC PARA CREAR TABLAS ==================================

const crearArchivo =async(m = 5, listar=false, hasta=20) =>{
    try{
        
    let salida = '';
     
    for (let i=1;i<=hasta;i++){      
        salida += `${m} x ${i} = ${m*i}\n`;
    }
    if (listar){
        console.log('=================');
        console.log('Tabla del:', m);
        console.log('=================');
        console.log(salida);
            }
    
    
    fs.writeFileSync(`./salida/tabla-${m}.txt`, salida);
    
    return `tabla-${m}.txt`;
} catch (error){
    throw error;
}
}
//===============================================================

module.exports={
    //cuando una function se llama igual que el metodo esto es redundante y puedo poner un solo nombre para que apunte a si mismo
    //crearArchivo:crearArchivo
    crearArchivo

}
