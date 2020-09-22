package com.ihc.apirest.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;



@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Entity
@Table(schema="dimension")
public class Cliente
{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long idCliente;
	private Long idBarrio;
	private String cedula;
	private String nombre;
	private String telefono;
	private String direccion;
	private String email;
	private Date fechaNacimiento;
	private String sexo;
	private String tipoCliente;
	private String password;
	private String barrio;

	@OneToMany(mappedBy = "cliente", cascade = CascadeType.ALL)
	private List<Visita> lstVisitas;
	
	@Transient
	private boolean tendero;

	public Cliente(Long idCliente) 
	{
		this.idCliente = idCliente;
	}

	public Cliente(Long idCliente, String nombre, boolean tendero) 
	{
		this.idCliente = idCliente;
		this.nombre = nombre;
		this.tendero = tendero;
	}
}