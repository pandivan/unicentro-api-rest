package com.ihc.apirest.repository;

import com.ihc.apirest.models.Aforo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;



@Repository
public interface AforoRepository extends JpaRepository<Aforo, Long>
{

    /**
     * Método que permite calcular el total de ingresos del dia
     */
    @Query(value = "select count(1) from hechos.aforo where fecha_ingreso is not null and fecha_ingreso >= CURRENT_DATE", nativeQuery = true)
    Long aforoClientesIngreso();


    /**
     * Método que permite calcular el total de salidas del dia
     */
    @Query(value = "select count(1) from hechos.aforo where fecha_salida is not null and fecha_salida >= CURRENT_DATE", nativeQuery = true)
    Long aforoClientesSalida();
}

