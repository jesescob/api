import ballerina/http;

// Definir la estructura de datos del producto
type Product record {
    string id;
    string nombre;
    int precio;
};

// Inicializar un arreglo de productos electrodomésticos
Product[] productList = [
    {id: "1", nombre: "Refrigerador", precio: 1500},
    {id: "2", nombre: "Lavadora", precio: 800},
    {id: "3", nombre: "Microondas", precio: 200}
];

// Crear el servicio API
service /api on new http:Listener(9090) {

    // Endpoint para obtener todos los productos electrodomésticos
    resource function get products() returns Product[] {
        return productList;
    }

   
}