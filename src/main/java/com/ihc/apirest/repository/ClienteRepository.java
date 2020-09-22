package com.ihc.apirest.repository;

import com.ihc.apirest.models.Cliente;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;



@Repository
public interface ClienteRepository extends JpaRepository<Cliente, Long>
{
    /**
     * Método que permite validar si el cliente existe
     * @param telefono Telefono del cliente
     * @param email Email del cliente
     * @param password Password del Cliente
     * @return Cliente
     */
    @Query("select c from Cliente c where (c.telefono = ?1 or c.email = ?2) and c.password = ?3")
    Cliente validarCliente(String telefono, String email, String password);

    /**
     * Método que permite obtener un cliente según la cedula
     * @param cedula Cedula del cliente a buscar
     * @return Cliente
     */
    Cliente findByCedula(String cedula);


    /**
     * Método que permite obtener un cliente según su email
     * @param email Email del cliente a buscar
     * @return Cliente
     */
    Cliente findByEmail(String email);


    /**
     * Método que permite calcular la cantidad de visitas que tiene acualtmente tiene la tienda
     */
    @Query(value = "SELECT count(id_visita) FROM hechos.visita WHERE id_tiempo = ?1", nativeQuery = true)
    Long aforoClientes(Long idTiempo);
}