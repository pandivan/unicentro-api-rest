package com.ihc.apirest.models;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

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
public class Aforo
{
    @Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long idAforo;
	private Date fechaIngreso;
	private Date fechaSalida;
}