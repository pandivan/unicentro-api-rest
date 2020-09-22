package com.ihc.apirest.models;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;


@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Entity
@Table(schema="hechos")
public class Visita
{
    @Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long idVisita;
	private Long idTienda;
	private Double temperatura;

	@JoinColumn(name = "idCliente")
	@ManyToOne(optional = false)
	@JsonIgnore
	private Cliente cliente;
}