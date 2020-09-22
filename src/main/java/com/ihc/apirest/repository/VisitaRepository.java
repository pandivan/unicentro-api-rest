package com.ihc.apirest.repository;

import com.ihc.apirest.models.Visita;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface VisitaRepository extends JpaRepository<Visita, Long>
{   
    // @Query("select t from Tienda t where (t.telefono = ?1 or t.email = ?2) and t.password = ?3")
    // Long countByIdTiempo(Long idTiempo);
}