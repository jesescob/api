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
    {id: "3", nombre: "Microondas", precio: 200},
    {id: "4", nombre: "Cocina", precio: 600}
];

// Crear el servicio API
service /api on new http:Listener(9090) {

    // Endpoint para obtener todos los productos electrodomésticos
    resource function get products() returns Product[] {
        return productList;
    }

    // Endpoint para agregar un producto electrodoméstico
    resource function post addProduct(http:Caller caller, http:Request request) {
        json|error productJson = request.getJsonPayload();
        if productJson is json {
            Product product = checkpanic productJson.cloneWithType(Product);
            productList.push(product);
            checkpanic caller->respond("Producto agregado exitosamente.");
        } else {
            checkpanic caller->respond("Error al procesar el objeto JSON del producto.");
        }
    }

    // Endpoint para eliminar un producto electrodoméstico por ID
    resource function delete deleteProduct(http:Caller caller, string productId) {
        int indexToDelete = -1;
        int i = 0;
        foreach Product product in productList {
            if product.id == productId {
                indexToDelete = i;
                break;
            }
            i += 1;
        }

        if indexToDelete != -1 {
            _ = productList.remove(indexToDelete);
            checkpanic caller->respond("Producto eliminado exitosamente.");
        } else {
            checkpanic caller->respond("Error: Producto no encontrado.");
        }
    }

    // Endpoint para actualizar el nombre y el precio de un producto por ID
    resource function put updateProduct(http:Caller caller, http:Request request, string productId) {
        json|error productJson = request.getJsonPayload();
        if productJson is json {
            Product updatedProduct = checkpanic productJson.cloneWithType(Product);
            int indexToUpdate = -1;
            int i = 0;
            foreach Product product in productList {
                if product.id == productId {
                    indexToUpdate = i;
                    break;
                }
                i += 1;
            }

            if indexToUpdate != -1 {
                productList[indexToUpdate] = updatedProduct;
                checkpanic caller->respond("Producto actualizado exitosamente.");
            } else {
                checkpanic caller->respond("Error: Producto no encontrado.");
            }
        } else {
            checkpanic caller->respond("Error al procesar el objeto JSON del producto.");
        }
    }
}