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
    id: 1,
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
        : reject(`No existe empelado con id ${id}`);
    });
    }

const getSalario = (id)=>{
    return new Promise((resolve, reject)=>{
        const salario = salarios.find(s => s.id ===id)?.salario;
        (salario)
        ? resolve(salario)
        : reject(`No existe salario para ${id}`);
    });
    }

let nombre;

const id = 1;
getEmpleado(id)
    .then (empleado => {
        nombre=empleado;
        return getSalario(id)
    })
    .then(salario => console.log('El empleado:', nombre, 'tiene un salario de:', salario));
    