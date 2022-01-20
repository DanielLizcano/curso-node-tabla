const empleados=[
    {
    id : 1,
    nombre : 'Juan'
},
{
    id: 2,
    nombre: 'Daniel'
},
{
    id: 3,
    nombre: 'Pedro'
},
];
const salarios=[
    {
        id:1,
        salario:1000
    },
    {
        id:2,
        salario:2000
    }
];

// const getEmpleado = ( id, callback )=> {
//     const empleado =empleados.find(e => e.id ===id)?.nombre
    
//     if (empleado) {
//         callback( null, empleado );
//     } else {
//         callback(`Empleado con id ${id} no existe`);
//     }
// }

// const getSalario = ( id, callback )=> {
//     const salario =salarios.find(s => s.id ===id)?.salario
    
//     if (salario) {
//         callback( null, salario );
//     } else {
//         callback(`No existe salario para el id ${id}`);
//     }
// }

const getEmpleado = (id)=>{
    return new Promise((resolve, reject)=>{
        const empleado = empleados.find(e => e.id ===id)?.nombre;
        (empleado)
        ? resolve(empleado)
        : reject(`No existe empleado con id ${id}`);
    });
    }

const getSalario = ()=>{
    return new Promise((resolve, reject)=>{
        const salario = salarios.find(s => s.id ===id)?.salario;
        (salario)
        ? resolve(salario)
        : reject(`No existe salario con ${id}`);
    });
    }

/*los metodos await deben estar dentro de una funcion o metodo asincrona*/ 
const getInfoUsuario= async(id)=>{
    try{
        const empleado = await getEmpleado(id);
        const salario = await getSalario(id);

        return `El salario del empleado: ${empleado} es de: ${salario}`;
    }catch (error){
        throw error;
    }
}

const id = 2;
getInfoUsuario(id)
    .then (msg => {
        console.log('TODO BIEN!')
        console.log(msg)})
    .catch( err => {
        console.log('TODO MAL!')
        console.log(err)});
